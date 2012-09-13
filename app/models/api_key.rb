class ApiKey < ActiveRecord::Base
	has_many :characters
	has_many :corporations

  # Queries EVE API for character information
  # Returns an array of all associated characters
  # returns an emtpy array if no characters were found
  def fetch_characters
    api = EVEAPI::API.new
    api.api_id = api_id
    api.v_code = v_code

    xml = api.get("account/APIKeyInfo")
    characters = []
    xml.xpath("//row").each do |row|
      characters << {
        :name => row['characterName'],
        :id => row['characterID'],
        :corporation_name => row['corporationName'],
        :corporation_id => row['corporationID'],
        :api_id => api_id,
        :v_code => v_code
      }
    end
    characters 
  end

  def create_characters_with_ids(character_ids)
    new_characters = []
    fetch_characters.map do |c|
      if character_ids.include? c[:id].to_i
        existing_character = Character.find_by_id(c[:id].to_i)
        if existing_character.present?
          existing_character.destroy unless existing_character.account_id
        end
        nc = characters.new
        nc.name = c[:name]
        nc.id = c[:id].to_i
        nc.api_update_for
        new_characters << nc
      end
    end
    new_characters
  end
end
