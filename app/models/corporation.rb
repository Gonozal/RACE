class Corporation < ActiveRecord::Base
  attr_accessor :api_id, :v_code
  
  has_many :characters

  # Eve Related Relationshipss
  has_many :wallet_transactions
  has_many :wallet_journals
  has_many :market_orders
  has_many :eve_assets
  has_many :contracts, foreign_key: :issuer_corp_id, conditions: "for_corp = 1"
  has_many :assigned_contracts, class_name: "Contract", foreign_key: :assignee_id
  
  def index
    
  end


  # Update publically available Corporation Data from API 
  def attributes_from_api
    # Set all neccessary API data
    api = EVEAPI::API.new
    api.corporation_id = self.id
    begin
      xml = api.get("corp/CorporationSheet")
    rescue Exception => e
      logger.error "EVE API Exception cought in Corporation.attributes_from_api!"
      logger.error e.inspect
      false
    else
      # Assign XML data to the corrosponding attributes
      self.name = xml.xpath('//corporationName').text
      self.id = xml.xpath('//corporationID').text
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
end
