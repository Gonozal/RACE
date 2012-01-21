class Corporation < ActiveRecord::Base
  attr_accessor :api_id, :v_code
  
  has_many :characters, :primary_key => :character_id
  
  def index
    
  end


  # Update publically available Corporation Data from API 
  def attributes_from_api
    # Set all neccessary API data
    api = EVEAPI::API.new
    api.corporation_id = self.corporation_id
    begin
      xml = api.get("corp/CorporationSheet")
    rescue Exception => e
      logger.error "EVE API Exception cought in Corporation.attributes_from_api!"
      logger.error e.inspect
      false
    else
      # Assign XML data to the corrosponding attributes
      self.name = xml.xpath('//corporationName').text
      self.corporation_id = xml.xpath('//corporationID').text
      self.ticker = xml.xpath('//ticker').text
      self.ceo_name = xml.xpath('//ceoName').text
      self.ceo_character_id = xml.xpath('//ceoID').text
      self.description = xml.xpath('//description').text
      self.url = xml.xpath('//url').text
      self.alliance_id = xml.xpath('//allianceID').text
      self.alliance_name = xml.xpath('//allianceName').text
      self.tax_rate = xml.xpath('//taxRate').text
      self.member_count = xml.xpath('//memberCount').text
    end
  end
  

  # # Obsolete method?
  # def extract_corporation_sheet_data(api_id, v_code)
  #   api = EVEAPI::API.new
  #   api.api_id = api_id
  #   api.v_code = v_code
    
  #   begin
  #     xml = api.corp.CorporationSheet.get
  #   rescue SocketError, EVEAPI::Exception => e
  #     logger.error "EVE API Exception cought in Corporation.extract_corporation_sheet_data!"
  #     logger.error e.inspect
  #     nil
  #   else
  #     corporation_data = {}
  #     corporation_data[:corporation_id] = xml.at_xpath("/corporationID")
  #     corporation_data[:name] = xml.at_xpath("/corporationName")
  #     corporation_data[:ticker] = xml.at_xpath("/ticker")
  #     corporation_data[:ceo_character_id] = xml.at_xpath("/ceoID")
  #     corporation_data[:ceo_name] = xml.at_xpath("/ceoName")
  #     corporation_data[:description] = xml.at_xpath("/description")
  #     corporation_data[:url] = xml.at_xpath("/url")
  #     corporation_data[:alliance_id] = xml.at_xpath("/allianceID")
  #     corporation_data[:alliance_name] = xml.at_xpath("/allianceName")
  #     corporation_data[:tax_rate] = xml.at_xpath("/taxRate")
  #     corporation_data[:member_count] = xml.at_xpath("/memberCount")
  #   end
  # end
end
