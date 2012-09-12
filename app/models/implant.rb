class Implant < ActiveRecord::Base
  belongs_to :character
  # Updates implants of a character
  # Warning: Also accepts a xml file 
  def api_update(xml = false)
    # First, delete all old implants
    begin
      api = set_api
      xml = api.get("char/CharacterSheet")
    rescue Exception => e
      logger.warn e.inspect
    else
      a = ["memory", "intelligence", "willpower", "perception", "charisma"]
      a.each do |attribute|
        attribute_xpath = "/eveapi/result/attributeEnhancers/" + attribute + "Bonus/augmentator"
        send(:"#{attribute}_name=", xml.xpath(attribute_xpath + "Name").text)
        send(:"#{attribute}_value=", xml.xpath(attribute_xpath + "Value").text.to_i)
      end
    end
    self.save
  end

  private
  # Sets API data from character object
  def set_api
    api = EVEAPI::API.new
    api.api_id = character.api_key.api_id
    api.v_code = character.api_key.v_code
    api.character_id = character.id
    api
  end
end
