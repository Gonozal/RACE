class SkillQueue < ActiveRecord::Base
  belongs_to :character
  # Update Attributes of current object from an API row
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
  end

  # Update Skill Queue from the eve API
  def self.api_update(params = {})
    queued_skills = []
    # create new API object
    api = set_api(params)

    # Delete all Queued skills of character
    params[:owner].queued_skills.delete_all

    begin
      # get mail headers XML
      xml = api.get("/char/SkillQueue")
    rescue Exception => e
      puts e.inspect
    else
      xml.xpath("/eveapi/result/rowset[@name='skillqueue']/row").each do |row|
        # Create new skill for each API row
        qs = params[:owner].queued_skills.new
        qs.attributes_from_row(row)
        queued_skills << qs
      end
    end
    save_queued_skills queued_skills
  end


  private
  # Sets API object with required attributes
  def self.set_api(params = {})
    api = EVEAPI::API.new
    api.api_id = params[:owner].api_key.api_id
    api.v_code = params[:owner].api_key.v_code
    api.character_id = params[:owner].id
    api
  end

  def self.save_queued_skills(queued_skills)
    SkillQueue.transaction do
      queued_skills.each do |qs|
        qs.save
      end
    end
  end
end
