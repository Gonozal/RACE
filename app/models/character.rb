class Character < ActiveRecord::Base
  attr_accessor :api_id, :v_code 
  
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

  #validates_uniqueness_of :id
  validates_uniqueness_of :name

  validates :api_id,     :numericality => true,
                          :presence => true,
                          :length => { :within => 3..32 }
  
  validates :v_code,     :format => { :with => /^[a-zA-Z0-9]+$/, :message => "must be alphanumerical" },
                          :presence => true,
                          :length =>{ :within => 5..96 }
                          
  before_save :check_character_corporations
  after_create :add_base_roles, :save_portrait
  after_destroy :destroy_portrait
  

  # return the role symbols needed for the declarative_authorization gem.
  # Basically loops through all the associated roles
  # 
  # @return [symbols, []] The role symbol array.
  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end
  
  
  # given the api_id and v_code have been stored in this account, fetces a list
  # of possible characters related to these API credentials.
  # uses the EVE API to get this list. Saves the result in a instance variable
  # to do some basic form of caching. That way validation methods
  # etc do not have to query the database or EVE API server again if they
  # need a list of possibly related characters
  # 
  # @param [integer] user_id The api_id (api related) for which to query the API
  # @param [string] api_key The APIKey (api related) for wihich to query the API
  # 
  # @raise [Exception] raises an Exception when there was an error with the API, internet
  #   connection, the response (invalid API) or if the API is blatantly invalid
  #   (see #valid_api_format?). For more information on possible errors see #EVEAPI::API.get
  # 
  # @return [[character]] An array of Characters
  def self.find_by_api!(api_id, v_code)
    unless valid_api_format?(api_id, v_code)
      raise EVEAPI::Exception::APIError.new('Invalid API Format')
    end
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

  # Given a Character object, updates Character data from the API
  # Updates: Gender, Race, Bloodline, Ancestry 
  # Updates: Clone Name, Clone SP, Attributes
  def update_character_sheet
    api = set_api
    begin
      xml = api.get("char/CharacterSheet")
    rescue Exception => e
      logger.error "EVE API Exception cought!"
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
  
  # About the same as #self.find_by_api! except that no exceptions are raised
  # but [] is returned.
  def self.find_by_api(api_id, v_code)
    begin
      find_by_api!(api_id, v_code)
    rescue Exception => e
      logger.error "EVE API Exception cought!"
      # logger.error e.inspect
      []
    end
  end
  
  # Check if provided API data is valid
  def valid_api?
    #Set API object
    api = EVEAPI::API.new
    api.api_id, api.v_code = api_key.api_id, api_key.v_code

    begin
      xml = api.get("account/APIKeyInfo")
    rescue Exception => e
      logger.error "EVE API Exception cought!"
      # logger.error e.inspect
    else
      if xml.xpath("/eveapi/result/key/rowset/row[@characterName='#{name}']").present?
        # If EVE API response contains the character name, return true
        return true
      end
    end
    false
  end


  # Every time a character is saved (created or updated), his Corporation is checked.
  # If his corporation does not yet exist, it is created
  def check_character_corporations
    if self.id_changed?
      unless Corporation.find_by_id(self.corporation_id).blank?
        true
      else
        corporation = Corporation.new
        corporation.id = corporation_id
        if corporation.attributes_from_api
          corporation.save
        end
      end
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
  # ensures that the supplied API data is valid
  def validate_api
    # only validate if either api_id, name or v_code have been changed
    if api_key.api_id_changed? or api_key.v_code_changed? or name_changed?
      unless valid_api?
        errors.add :v_code, 'invalid vCode or Api ID'
        false
      end
    end
    true
  end
  
  # validates the API format just as 'validate_api_format' does but does not add errors
  def self.valid_api_format?(api_id, v_code)
    api_id.to_s =~ /^[1-9][0-9]+$/ and v_code =~ /^[a-zA-Z0-9]{64,64}$/
  end
  
  def valid_api_format?
    api_id ||= api_key.api_id
    v_code ||= api_key.v_code
    self.valid_api_format?(api_id, v_code)
  end
  
  def save_portrait
    Resque.enqueue(ApiImageBackgrounder, 'character', id, [32,64,128,256])
  end
  
  def destroy_portrait
    Resque.enqueue(ApiImageBackgrounder, 'character', id, nil, true)
  end
  
  # Temporary Roles allocation based on character name
  def add_base_roles
    self.roles.create(:title => "goon")
    if self.name.eql? "Lerado Mendar"
      self.roles.create(:title => "admin")
    elsif self.name.eql? "Hector Wrathic"
      self.roles.create(:title => "member")
    end
  end
end