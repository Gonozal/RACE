class Implant < ActiveRecord::Base
  belongs_to :character
  # Updates implants of a character
  # Warning: Also accepts a xml file 
  def self.api_update(character, xml = false)
    # First, delete all old implants
    logger.warn character.to_yaml
    unless xml
      begin
        api = set_api(character)
        xml = api.get("char/CharacterSheet")
      rescue Exception => e
        logger.error "EVE API Exception cought!"
      end
    end
    implants = []

    # Go through all Implants and add them to array
    character.implants.delete_all
    implants << set_attribute_enhancer(character, xml, "memory")
    implants << set_attribute_enhancer(character, xml, "perception")
    implants << set_attribute_enhancer(character, xml, "willpower")
    implants << set_attribute_enhancer(character, xml, "intelligence")
    implants << set_attribute_enhancer(character, xml, "charisma")

    # Save implants
    Implant.transaction do
      implants.each do |implant|
        implant.save
      end
    end
  end

  private
  # Sets API data from character object
  def self.set_api(character)
    api = EVEAPI::API.new
    api.api_id = character.api_id
    api.v_code = character.v_code
    api.character_id = character.id
    api
  end

  # Set Atribute name and Bonus
  def self.set_attribute_enhancer(character, xml, type)
    i = character.implants.new
    i.augmentator_name = xml.xpath("/eveapi/result/attributeEnhancers/" + type + "Bonus/augmentatorName").text
    i.augmentator_value = xml.xpath("/eveapi/result/attributeEnhancers/" + type + "Bonus/augmentatorValue").text.to_i
    i
  end
end
