require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @api_key = "A7416C2DAA5D4283AE4EE7BB8F27BDBC96F3A01B14534656842A9783AC135A8A"
    @user_id = 1144806
    @character_id = 465753202
    @character_name = "Mr Printman"
    @related_characters = ["Mr Printman", "Mr Labman", "Jerppu3"]
  end
  
  test "getting list of characters through EVE API" do
    char = Character.new
    char.v_code = @api_key
    char.api_id = @user_id
    chars = char.get_related_characters
    chars.map! { |c| c[:name] }
    
    assert_equal [], chars - @related_characters
    assert_equal [], @related_characters - chars
  end
  
  test "API key validation with valid API key" do
    char = Character.new
    char.v_code = @api_key
    char.api_id = @user_id
    char.valid?
    
    assert char.errors[:v_code].blank?
  end
  
  test "API key validation with invalid API key" do
    char = Character.new
    char.v_code = @api_key
    char.api_id = "some invalid stuff"
    char.valid?
    
    assert !char.errors[:v_code].blank?
  end
end
