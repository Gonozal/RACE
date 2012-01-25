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
    api.api_id = params[:owner].api_id
    api.v_code = params[:owner].v_code
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

    # Delete all Mailerships for this user
    params[:owner].mailerships.delete_all

    begin
      # Get Data for all Currently learned skills
      xml = api.get("/char/mailinglists")
    rescue Exception => e
      puts e.inspect
    else
      # Get all mailing lists of the user (and create lists that are not already in the DB)
      params[:xml] = xml
      mailerships = get_api_mailerships(params)

      # Update mailerships of user (membership in mailing lists)
      Mailership.transaction do
        mailerships.each do |m|
          params[:owner].mailing_lists << m
        end
      end
    end
  end

  def self.get_api_mailerships(params = {})
    mailerships = []
    params[:xml].xpath("/eveapi/result/rowset[@name='mailingLists']/row").each do |row|
      # Find or Create mailing List
      ml = MailingList.find_or_initialize_by_id(row['listID'].to_i)
      ml.display_name = row['displayName']
      ml.save

      logger.warn "INCOOMING"
      logger.warn row['displayName']
      logger.warn row['listID'].to_i
      logger.warn params[:owner].id
      logger.warn "OUTCOMING"
      if Mailership.where("character_id = ? AND mailing_list_id = ?", params[:owner].id ,row['listID'].to_i).all.blank?
        mailerships << ml
        logger.warn "no match Found"
      else 
        logger.warn "Match found"
      end
    end
    logger.warn mailerships
    mailerships
  end


end
