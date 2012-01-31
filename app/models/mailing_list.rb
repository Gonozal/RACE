class MailingList < ActiveRecord::Base
  has_many :mailerships
	has_many :characters, through: :mailerships

  # Update Attributes of current MT object from 
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
  end

  def self.set_api(params = {})
    api = EVEAPI::API.new
    api.api_id = params[:owner].api_key.api_id
    api.v_code = params[:owner].api_key.v_code
    api.character_id = params[:owner].id
    api
  end

  def self.api_update_own(params = {})
    # Check if we have a Character her, this API is only valid for characters
    unless params[:owner].instance_of?(Character)
      return false
    end
    # Create new API Object and set relevant attributes
    api = set_api(params)

    begin
      # Get Data for all Currently learned skills
      xml = api.get("/char/mailinglists")
    rescue Exception => e
      puts e.inspect
    else
      # Delete all Mailerships for this user
      params[:owner].mailing_lists.delete_all

      # Get all mailing lists of the user
      params[:xml] = xml
      new_lists = get_api_mailing_lists(params)

      # Update DB to reflect changes
      update_lists(params[:owner], new_lists)
    end
  end

  def self.get_api_mailing_lists(params = {})
    new_lists = []
    params[:xml].xpath("/eveapi/result/rowset[@name='mailingLists']/row").each do |row|
      # Find or Create mailing List
      ml = MailingList.find_or_initialize_by_id(row['listID'].to_i)
      ml.display_name = row['displayName']
      new_lists << ml
    end
    new_lists
  end

  def self.update_lists(owner, new_lists)
    # Update mailing lists (membership in mailing lists)
      MailingList.transaction do
        new_lists.each do |m|
          m.save
        end
      end

      # Update mailerships of user (membership in mailing lists)
      Mailership.transaction do
        new_lists.each do |m|
          owner.mailing_lists << m
        end
      end
  end
end
