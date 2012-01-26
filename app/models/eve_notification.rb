class EveNotification < ActiveRecord::Base
  has_and_belongs_to_many :characters
  # Update Attributes of current object from an API row
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    send(:id=, params['notificationID'])
  end

  # Update new notifications from the eve API
  def self.api_update(params = {})
    # create new API object
    api = set_api(params)
    new_notifications = {}
    
    begin
      # get mail headers XML
      xml = api.get("/char/Notifications")
      logger.warn xml
    rescue Exception => e
      puts e.inspect
    else
      xml.xpath("/eveapi/result/rowset[@name='notifications']/row").each do |row|
        en = EveNotification.new
        en.attributes_from_row(row)
        new_notifications[en.id.to_s] = en
      end
    end
    # Remove duplicate mails
    new_notifications = remove_duplicate_notifications(new_notifications, params[:owner])
    
    # Only continue if there are still mails left to be processed
    unless new_notifications.empty?
      # get Mail Bodies (text) for remaining new_mail-IDs
      new_notifications = api_update_contents(new_notifications, api)

      # Insert mails into DB
      EveNotification.transaction do
        new_notifications.each_value do |notification|
          params[:owner].eve_notifications << notification
        end
      end
    end
  end

  # Updates Mail bodies by extracting Mail IDs from an array of mails 
  def self.api_update_contents(new_notifications = {}, api)
    api.ids = new_notifications.keys.join(",")
    begin
      xml = api.get("/char/NotificationTexts")
    rescue Exception => e
      puts e.inspect
    else
      xml.xpath("/eveapi/result/rowset[@name='notifications']/row").each do |row|
        # Remove first 9 and last 3 Characters from notification body ("<![CDATA[", "]]>")
        new_notifications[row['notificationID']].content = row.text[9..-3]
      end
    end
    new_notifications
  end



  private
  # Gets an array of mails that are already in the DB and 
  # removes them from a new_mails hash
  # INPUT: {"mail_id" => EveMail}
  # OUTPUT: {"mail_id" => EveMail} truncated by mail IDs already in the db
  def self.remove_duplicate_notifications(new_notifications = {}, owner) 
    duplicate_notifications = owner.eve_notifications.where(:id => new_notifications.keys).select(:id).all
    duplicate_notifications.map! do |x|
      x.id
    end
    # Removes all mails from new_mails array that are already in the DV
    new_notifications.reject! do |key, value|
      duplicate_notifications.include?(key.to_i)
    end
    new_notifications
  end


  # Sets API object with required attributes
  def self.set_api(params = {})
    api = EVEAPI::API.new
    api.api_id = params[:owner].api_id
    api.v_code = params[:owner].v_code
    api.character_id = params[:owner].id
    api
  end
end
