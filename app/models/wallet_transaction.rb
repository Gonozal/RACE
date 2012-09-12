class WalletTransaction < ActiveRecord::Base
  include Comparable

  attr_accessor :transaction_date_time

  belongs_to :corporation
  belongs_to :character

  # Format UNIX Timestampt to EVE-formated datetime string
  # format is: YYYY-MM-DD - hh:mm:ss (24h format)
  def transaction_date_time
    Time.at(transaction_time).to_formatted_s(:db)
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
    self.transaction_time = Time.parse(params[:transactionDateTime]).to_i
  end

  # Update wallet Transactions for all Divisions of provided :owner
  # This is possible for Characters and Corporations
  # TODO: Check if Corp Transactions are handled correctly
  def self.api_update_for(params = {})
    # Create new API object and assign API-related values
    api = EVEAPI::API.new
    api.api_id, api.v_code = params[:owner].api_key.api_id, params[:owner].api_key.v_code
    api.character_id = params[:owner].id

    wallet_transactions = params[:owner].wallet_transactions
    # Set some basic params for api_update_devision
    params.merge!({
      api: api,
      account_key: 1000,
      all_transactions: [],
      succesfully_saved: [],
      newest_transaction_time: (wallet_transactions.any?)? wallet_transactions.order("transaction_time DESC").first.transaction_time : 0
    })

    if params[:owner].instance_of?(Character)
      # If we are updating Character transactions, go right ahead
      params[:xml_path] = "char/WalletTransactions"
      api_update_division(params)
    elsif params[:owner].instance_of?(Corporation)
      params[:xml_path] = "corp/WalletTransactions"
      # If we are updating Corp transactions, do it for all devisions
      7.times do |i|
        params[:account_key] = 1000 + i
        api_update_division(params)
      end
    else
      # If owner is neither Corporation nor Character, there's nothing we can do
      false
    end

    # We  should now have all Transactions stored in params[:all_transactions]
    # Start inserting it and returning the hash with all Transactions
    WalletTransaction.transaction do
      params[:all_transactions].each do |t|
        # Populate array with succesfully saved transactions
        if t.save
          params[:succesfully_saved] << t
        end
      end
    end
    # Return sucesfully saved Transactions
    params[:succesfully_saved]
  end

  # Update a single division of :owner's wallet Transactions.
  def self.api_update_division(params = {})
    current_transactions = []
    params[:api].account_key = params[:account_key]
    xml = params[:api].get(params[:xml_path])
    # Loop over all Transaction rows supplied by the EVE API
    xml.xpath("/eveapi/result/rowset[@name='transactions']/row").each do |row|
      mt = params[:owner].wallet_transactions.new
      mt.attributes_from_row(row)
      # Only add Transaction to Array if it's newer than the newest
      # DB-entry for this user. In short: only add new stuff
      if mt.transaction_time > params[:newest_transaction_time]
        mt.account_key = params[:account_key]
        current_transactions << mt
      end
    end
    # Sort transactions (can be more or less randomly ordered) to prepare
    # "Jorunal Walking" and append transactions fetches this iteration to total
    # fetched transactions (recursion)
    params[:all_transactions] << current_transactions.sort!
    
    if(current_transactions.size >= 1000)
      # If we did not get the Maximum amount of transactions, repeat
      params[:api].from_id = current_transactions.last.transaction_id
      api_update_division(params)
    else
      # If we got everything, return it for further processing
      params[:all_transactions].flatten!
    end
  end

  def <=>(other)
    "#{transaction_time}" <=> "#{other.transaction_time}"
  end
end
