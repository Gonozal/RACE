class WalletJournal < ActiveRecord::Base
  include Comparable

  attr_accessor :journal_date_time

  belongs_to :corporation
  belongs_to :character

  # Format UNIX Timestampt to EVE-formated datetime string
  # format is: YYYY-MM-DD - hh:mm:ss (24h format)
  def journal_date_time
    Time.at(date).to_formatted_s(:db)
  end

  # Update Attributes of current MT object from 
  def attributes_from_row (params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    self.date = Time.parse(params[:date]).to_i
  end

  # Update wallet journals for all Divisions of provided :owner
  # This is possible for Characters and Corporations
  # TODO: Check if Corp journals are handled correctly
  def self.api_update_own(params = {})
    # Create new API object and assign API-related values
    api = EVEAPI::API.new
    api.api_id, api.v_code = params[:owner].api_id, params[:owner].v_code
    api.character_id,  = params[:owner].id, 2560

    wallet_journals = params[:owner].wallet_journals
    # Set some basic params for api_update_devision
    params.merge!({
      api: api,
      account_key: 1000,
      all_journals: [],
      succesfully_saved: [],
      newest_journal_time: (wallet_journals.any?)? wallet_journals.order("date DESC").first.date : 0
    })
    if params[:owner].instance_of?(Character)
      # If we are updating Character journals, go right ahead
      params[:xml_path] = "char/Walletjournal"
      api_update_division(params)
    elsif params[:owner].instance_of?(Corporation)
      params[:xml_path] = "corp/Walletjournal"
      # If we are updating Corp journals, do it for all devisions
      7.times do |i|
        params[:account_key] = 1000 + i
        api_update_division(params)
      end
    else
      # If owner is neither Corporation nor Character, there's nothing we can do
      false
    end
    
    # We  should now have all Journal entries stored in params[:all_transactions]
    # Start inserting it and returning the hash with all Journal entries 
    WalletJournal.transaction do
      params[:all_journals].each do |j|
        # Populate array with succesfully saved Journal entries 
        if j.save
          params[:succesfully_saved] << j
        end
      end
    end
    # Return all Journal entries 
    params[:succesfully_saved]
  end

  # Update a single division of :owner's wallet journals.
  def self.api_update_division(params = {})
    current_journals = []
    params[:api].account_key = params[:account_key]
    xml = params[:api].get(params[:xml_path])
    # Loop over all journal rows supplied by the EVE API
    xml.xpath("/eveapi/result/rowset[@name='transactions']/row").each do |row|
      mt = params[:owner].wallet_journals.new
      mt.attributes_from_row(row)
      # Only add journal to Array if it's newer than the newest
      # DB-entry for this user. In short: only add new stuff
      if mt.date > params[:newest_journal_time]
        mt.account_key = params[:account_key]
        current_journals << mt
      end
    end
    # Sort journals (can be more or less randomly ordered) to prepare "Jorunal Walking" and
    # append journals fetches this iteration to total fetched journals (recursion)
    params[:all_journals] << current_journals.sort!
    
    if(current_journals.size >= 1000)
      # If we did not get the Maximum amount of journals, repeat
      params[:api].from_id = current_journals.last.journal_id
      api_update_division(params)
    else
    	# If we got everything, return it for further processing
      params[:all_journals].flatten!
    end
  end

  def <=>(other)
    "#{date}" <=> "#{other.date}"
  end
end
