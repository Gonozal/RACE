require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  def setup
    @api_key = "A7416C2DAA5D4283AE4EE7BB8F27BDBC96F3A01B14534656842A9783AC135A8A"
    @user_id = 1144806
    @character_id = 465753202
    @character_name = "Mr Printman"
  end
  
  test "get character name bevore validation" do
    char = Character.new
    char.v_code = @api_key
    char.api_id = 1144806
    char.character_id = 465753202
    char.valid?
    
    assert_equal @character_name, char.name, "Character name not succesfully retrieved from API Data before validation"
  end
end
