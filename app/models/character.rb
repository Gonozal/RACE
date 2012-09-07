class Character < ActiveRecord::Base
  attr_accessor :api_id, :v_code, :main_character

  # FIXME: attribute_accessible missing!
  belongs_to :account
  belongs_to :corporation
  belongs_to :api_key

  has_many :roles

  # Eve Related Relationshipss
  has_many :skills
  has_many :queued_skills, class_name: "SkillQueue", foreign_key: :character_id
  has_many :wallet_transactions
  has_many :wallet_journals
  has_many :market_orders
  has_many :eve_assets
  has_many :contracts, foreign_key: :issuer_id
  has_many :assigned_contracts, class_name: "Contract", foreign_key: :assignee_id
  has_many :implants
  has_many :eve_roles
  has_many :industry_jobs, foreign_key: :installer_id
  # Mails & Mailing Lists
  has_many :mailerships
  has_many :mailing_lists, through: :mailerships
  has_and_belongs_to_many :eve_notifications

  # before_save :check_character_corporations
  after_create :add_base_roles, :save_portrait
  after_destroy :destroy_portrait

  # return the role symbols needed for the declarative_authorization gem.
  # Basically loops through all the associated roles
  # 
  # @return [symbols, []] The role symbol array.
  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end

  # Given a Character object, updates Character data from the API
  # Updates: Gender, Race, Bloodline, Ancestry 
  # Updates: Clone Name, Clone SP, Attributes
  def update_character_sheet
    api = set_api
    begin
      xml = api.get("char/CharacterSheet")
    rescue Exception => e
      logger.error "EVE API Exception cought!"
      logger.error e.inspect
    else
      # Update date of birth manually because of discrepancy between DB and API name
      self.date_of_birth = xml.xpath('/eveapi/result/DoB').text
      # Set Array containing xml paths
      a = ["race", "bloodLine", "ancestry", "gender", "corporationName",
        "corporationID", "cloneName", "cloneSkillPoints", "balance",
        "attributes/intelligence", "attributes/memory", "attributes/charisma",
        "attributes/perception", "attributes/willpower"]
      # Update attributes using the XML paths 
      a.each do |param|
        param_u = param.gsub("attributes/", "").underscore
        if respond_to?(:"#{param_u}=")
          send(:"#{param_u}=", xml.xpath("/eveapi/result/" + param).text)
        end
      end
      self.save

      # Update implants rowset
      Implant.api_update(self, xml)
      EveRole.api_update(self, xml)
    end
  end

  # Sets API data from character object
  def set_api
    api = EVEAPI::API.new
    api.api_id = api_key.api_id
    api.v_code = api_key.v_code
    api.character_id = id
    api
  end

  private
  def save_portrait
    Resque.enqueue(ApiImageBackgrounder, 'character', id, [32,64,128,256])
  end

  def destroy_portrait
    Resque.enqueue(ApiImageBackgrounder, 'character', id, nil, true)
  end

  # Temporary Roles allocation based on character name
  def add_base_roles
    self.roles.create(:title => "goon")
    if self.name.eql? "Grandor Eldoran"
      self.roles.create(:title => "admin")
    elsif self.name.eql? "Test2 Test2"
      self.roles.create(:title => "member")
    end
  end
end
