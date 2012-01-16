class Character < ActiveRecord::Base
  # FIXME: attribute_accessible missing!
  belongs_to :account
  belongs_to :corporation, :primary_key => :corporation_id
  has_many :roles
  
  validates_uniqueness_of :character_id
  validates_uniqueness_of :name

  validates :user_id,     :numericality => true,
                          :presence => true,
                          :length => { :within => 3..32 }
  
  validates :api_key,     :format => { :with => /^[a-zA-Z0-9]+$/, :message => "must be alphanumerical" },
                          :presence => true,
                          :length =>{ :within => 5..96 }
                          
  before_save :check_character_corporations
  after_create :add_base_roles, :save_portrait
  after_destroy :destroy_portrait
  
  # return the role symbols needed for the declarative_authorization gem.
  # Basicly loops through all the associated roles 
  # 
  # @return [symbols, []] The role symbol array.
  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end
  
  
  # given the user_id and api_key have been stored in this account, fetches a list
  # of possible characters related to these API credentials.
  # uses the EVE API to get this list. Saves the result in a instance variable
  # to do some basic form of caching. That way validation methods
  # etc do not have to query the database or EVE API server again if they
  # need a list of possibly related characters
  # 
  # @param [integer] user_id The user_id (api related) for which to query the API
  # @param [string] api_key The APIKey (api related) for wihich to query the API
  # 
  # @raise [Exception] raises an Exception when there was an error with the API, internet
  #   connection, the response (invalid API) or if the API is blatantly invalid
  #   (see #valid_api_format?). For more information on possible errors see #EVEAPI::API.get
  # 
  # @return [[character]] An array of Characters
  def self.find_by_api!(user_id, api_key)
    return @characters unless @characters.nil?
    unless valid_api_format?(user_id, api_key)
      raise EVEAPI::Exception::APIError.new('Invalid API Format') 
    end
    
    api = EVEAPI::API.new
    api.user_id = user_id
    api.api_key = api_key
    
    xml = api.get("account/Characters")
    characters = []
    xml.xpath("//row").each do |row|
      characters << {
        :name => row['name'],
        :character_id => row['characterID'],
        :corporation_name => row['corporationName'],
        :corporation_id => row['corporationID'],
        :user_id => user_id,
        :api_key => api_key
      }
    end
    @characters = characters 
  end
  
  # About the same as #self.find_by_api! except that no exceptions are raised
  # but [] is returned.
  def self.find_by_api(user_id, api_key)
    begin
      find_by_api!(user_id, api_key)
    rescue Exception => e
      logger.error "EVE API Exception cought!"
      logger.error e.inspect
      []
    end
  end
  
  # Check if provided API data is valid
  # Valid means: At least access to the "skillInTraining" API
  def valid_api?
    api = EVEAPI::API.new
    api.user_id = user_id
    api.character_id = character_id
    api.api_key = api_key
    
    begin
      xml = api.get("char/SkillInTraining")
    rescue Exception => e
      logger.error "EVE API Exception cought!"
      logger.error e.inspect
    else
      if xml.xpath('//skillInTraining').text.present?
        true
      end
    end
    false
  end

  private
  # ensures that the supplied API data is valid
  def validate_api
    # only validate if either user_id, name or api_key have been changed
    if user_id_changed? or api_key_changed? or name_changed?
      unless valid_api?
        errors.add :api_key, 'invalid API Key or User ID'
        false
      end
    end
    true
  end
  
  # validates the API format just as 'validate_api_format' does but does not add errors
  def self.valid_api_format?(user_id, api_key)
    user_id.to_s =~ /^[1-9][0-9]+$/ and api_key =~ /^[a-zA-Z0-9]{5,}$/
  end
  
  def valid_api_format?
    self.valid_api_format?(user_id, api_key)
  end
  
  def save_portrait
    Resque.enqueue(ApiImageBackgrounder, 'character', character_id, [32,64,128,256])
  end
  
  def destroy_portrait
    Resque.enqueue(ApiImageBackgrounder, 'character', character_id, nil, true)
  end
  
  # Every time a character is saved (created or updated), his Corporation is checked.
  # If his corporation does not yet exist, it is created
  def check_character_corporations
    if self.corporation_id_changed?
      unless Corporation.find_by_corporation_id(self.corporation_id).blank?
        true
      else
        api = EVEAPI::API.new
        api.user_id = user_id
        api.api_key = api_key
        api.character_id = character_id
        
        corporation = Corporation.new
        begin
          xml = api.get("corp/CorporationSheet")
        rescue Exception => e
          logger.error "EVE API Exception cought!"
          logger.error e.inspect
          false
        else
          corporation.name = xml.xpath('//corporationName').text
          corporation.corporation_id = xml.xpath('//corporationID').text
          corporation.ticker = xml.xpath('//ticker').text
          corporation.ceo_name = xml.xpath('//ceoName').text
          corporation.ceo_character_id = xml.xpath('//ceoID').text
          corporation.description = xml.xpath('//description').text
          corporation.url = xml.xpath('//url').text
          corporation.alliance_id = xml.xpath('//allianceID').text
          corporation.alliance_name = xml.xpath('//allianceName').text
          corporation.tax_rate = xml.xpath('//taxRate').text
          corporation.member_count = xml.xpath('//memberCount').text
          
          corporation.save
        end
      end
    end
  end
  
  def add_base_roles
    self.roles.create(:title => "goon")
    if self.name.eql? "Mr Printman"
      self.roles.create(:title => "member")
    elsif self.name.eql? "Jerppu3"
      self.roles.create(:title => "admin")
    end
  end
end