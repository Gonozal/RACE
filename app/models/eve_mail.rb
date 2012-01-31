class EveMail < ActiveRecord::Base
  # Update Attributes of current object from an API row
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    send(:to_character_ids=, params['toCharacterIDs'])
    send(:id=, params['messageID'])
  end

  # Update new eve-mails from the eve API
  def self.api_update(params = {})
    # create new API object
    api = set_api(params)
    new_mails = {}
    
    begin
      # get mail headers XML
      xml = api.get("/char/MailMessages")
    rescue Exception => e
      puts e.inspect
    else
      xml.xpath("/eveapi/result/rowset[@name='messages']/row").each do |row|
        em = EveMail.new
        em.attributes_from_row(row)
        new_mails[em.id.to_s] = em
      end
    end
    # Remove duplicate mails
    new_mails = remove_duplicate_mails(new_mails)
    
    # Only continue if there are still mails left to be processed
    unless new_mails.empty?
      # get Mail Bodies (text) for remaining new_mail-IDs
      new_mails = api_update_bodies(new_mails, api)

      # Insert mails into DB
      EveMail.transaction do
        new_mails.each_value do |mail|
          mail.save
        end
      end
    end
  end

  # Updates Mail bodies by extracting Mail IDs from an array of mails 
  def self.api_update_bodies(new_mails = {}, api)
    api.ids = new_mails.keys.join(",")
    begin
      xml = api.get("/char/MailBodies")
    rescue Exception => e
      puts e.inspect
    else
      xml.xpath("/eveapi/result/rowset[@name='messages']/row").each do |row|
        # Remove first 9 and last 3 Characters from mail body ("<![CDATA[", "]]>")
        new_mails[row['messageID']].body = row.text[9..-3]
      end
    end
    new_mails
  end



  private
  # Gets an array of mails that are already in the DB and 
  # removes them from a new_mails hash
  # INPUT: {"mail_id" => EveMail}
  # OUTPUT: {"mail_id" => EveMail} truncated by mail IDs already in the db
  def self.remove_duplicate_mails(new_mails = {}) 
    duplicate_mails = EveMail.where(:id => new_mails.keys).select(:id).all
    duplicate_mails.map! do |x|
      x.id
    end
    # Removes all mails from new_mails array that are already in the DV
    new_mails.reject! do |key, value|
      duplicate_mails.include?(key.to_i)
    end
    new_mails
  end


  # Sets API object with required attributes
  def self.set_api(params = {})
    api = EVEAPI::API.new
    api.api_id = params[:owner].api_key.api_id
    api.v_code = params[:owner].api_key.v_code
    api.character_id = params[:owner].id
    api
  end
end
