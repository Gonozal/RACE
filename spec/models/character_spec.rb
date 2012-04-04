require 'spec_helper'

describe Character do
  describe "valid_api_format?" do
    it "should return false api is not formated properly" do
      api_id = 12345
      v_code= "Test123"
      Character.valid_api_format?(api_id, v_code).should be_false
    end

    it "should return true if api is formated properly" do
      api_id = 123456
      v_code = "fiK6221WZBqDI3DWDKHEWZz4ucIc69FAQxmfykmpJ1AZYYT9TDsabp39WCREnzeK"
      Character.valid_api_format?(api_id, v_code).should be_true
    end
  end

  describe "valid_api?" do
    it "should fail if API is not formated properly" do
      # Create new character
      c = Character.new
      c.id = 1175431904
      c.name = "Lerado Mendar"
      a = ApiKey.create!(api_id: 539347, v_code: "fiK6Jl3WZBqDI3DWDKHEWZz4ucIc69F1QxmfykmpJ1AZYYT9TBpavy39WCREnze")
      c.api_key_id = a.id

      c.valid_api?.should be_false
    end

    it "should fail if API is formated properly but invalid" do
      # Create new character
      c = Character.new
      c.id = 1175431904
      c.name = "Lerado Mendar"
      a = ApiKey.create!(api_id: 539347, v_code: "fiK6Jl3WZBqDI3DWDKHEWZz4ucIc69F1QxmfykmpJ1AZYYT9TBpavy39WCREnzeR")
      c.api_key_id = a.id

      c.valid_api?.should be_false
    end

    it "should fail if API is valid but for the wrong character" do
      # Create new character
      c = Character.new
      c.id = 1175431904
      c.name = "Hector Wrathic"
      a = ApiKey.create!(api_id: 535544, v_code: "nop41zYTepo9n3BNLbcGMBYnIuEEVE81v7o00COK784YFRMv05yP75bt1nEmvTgO")
      c.api_key_id = a.id

      c.valid_api?.should be_false
    end
  end
end
 