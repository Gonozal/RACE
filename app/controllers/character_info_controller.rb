class CharacterInfoController < ApplicationController
  def skills
    character = current_user
    character_info = CharacterInfo.new
    @skills = character_info.skills(character.user_id, character.character_id, character.api_key)
  end
  
  def mails
  end
  
  def assets
  end
end
