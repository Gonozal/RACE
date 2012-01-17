class CharacterInfoController < ApplicationController
  def skills
    character = current_user
    character_info = CharacterInfo.new
    @skills = character_info.skills(character.api_id, character.character_id, character.v_code)
  end
  
  def mails
  end
  
  def assets
  end
end
