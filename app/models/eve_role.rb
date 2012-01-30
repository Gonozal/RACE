class EveRole < ActiveRecord::Base
  belongs_to :character
  # Updates eve online Roles from API
  # Warning: Also accepts a xml file 
  def self.api_update(character, xml = false)
    # First, delete all old implants
    unless xml
      begin
        api = set_api(character)
        xml = api.get("char/CharacterSheet")
      rescue Exception => e
        logger.error "EVE API Exception cought!"
      end
    end
    roles = []

    # Go through all Implants and add them to array
    character.eve_roles.delete_all
    roles << set_role_type(character, xml, "")
    roles << set_role_type(character, xml, "AtHQ")
    roles << set_role_type(character, xml, "AtBase")
    roles << set_role_type(character, xml, "AtOther")


    roles.flatten!
    # Save implants
    EveRole.transaction do
      roles.each do |role|
        role.save
      end
    end
  end

  # Set Atribute name and Bonus
  def self.set_role_type(character, xml, type = "")
    roles = []
    xml.xpath("/eveapi/result/rowset[@name='corporationRoles" + type + "']/row").each do |role|
      r = character.eve_roles.new
      r.role_id = role['roleID']
      r.role_name = role['roleName']
      r.role_type = type.underscore
      roles << r
    end
    roles
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
end
