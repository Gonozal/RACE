class Corporation < ActiveRecord::Base
  attr_accessor :user_id, :api_key
  
  has_many :characters, :primary_key => :character_id
  
  def index
    
  end
  
  def extract_corporation_sheet_data(user_id, api_key)
    api = EVEAPI::API.new
    api.user_id = user_id
    api.api_key = api_key
    
    begin
      xml = api.corp.CorporationSheet.get
    rescue SocketError, EVEAPI::Exception => e
      logger.error "EVE API Exception cought!"
      logger.error e.inspect
      nil
    else
      corporation_data = {}
      corporation_data[:corporation_id] = xml.at_xpath("/corporationID")
      corporation_data[:name] = xml.at_xpath("/corporationName")
      corporation_data[:ticker] = xml.at_xpath("/ticker")
      corporation_data[:ceo_character_id] = xml.at_xpath("/ceoID")
      corporation_data[:ceo_name] = xml.at_xpath("/ceoName")
      corporation_data[:description] = xml.at_xpath("/description")
      corporation_data[:url] = xml.at_xpath("/url")
      corporation_data[:alliance_id] = xml.at_xpath("/allianceID")
      corporation_data[:alliance_name] = xml.at_xpath("/allianceName")
      corporation_data[:tax_rate] = xml.at_xpath("/taxRate")
      corporation_data[:member_count] = xml.at_xpath("/memberCount")
    end
  end
end
