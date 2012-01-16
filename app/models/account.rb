# The account Class. Holds all information for a user account including authentication 
# information (name, password, email address etc).
# 
# One Account can have many characters which need to be valid EVE Online characters. (see Character)
# An Account also has only one main_character
class Account < ActiveRecord::Base
  # FIXME: is this right?
  # Hash password
  attr_accessible :name, :email, :email_confirmation, :password, :password_confirmation
  
  attr_accessor :password
  
  attr_accessible :name, :password, :password_confirmation, :email, :email_confirmation
  
  before_save :encrypt_password
  
  validates :name,      :format => {:with => /^[\w][\w\d ]+$/, :message => "must only contain alphanumeric characters and start with a letter"},
                        :uniqueness => true,
                        :length => {:within => 3..24},
                        :presence => true
                    
  validates :password,  :length => {:within => 5..64},
                        :confirmation => true,
                        :presence => true
                        
  validates :email,     :format => {
                          :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                          :message => "not a valid email address"
                        },
                        :confirmation => true,
                        :uniqueness => true,
                        :presence => true

  has_many :characters, :dependent => :destroy, :include => :roles
  belongs_to :main_character, :class_name => "Character"
  
  # authenticates an account by account_id and password salt
  # 
  # @param [integer] id The id of the account to authenticate
  # @param [string] the salt of the account PW that is to be compared to the stored salt
  # 
  # @return [Account, nil] the authenticated account or nil if authentication was not successfull
  def self.authenticated_with_token(id, stored_salt)
    @account = Account.find_by_id(id, :include => :characters)
    @account && @account.password.salt == stored_salt ? @account : nil
  end
  
  # does basicly the same as #authenticated_with_token except that not a user ID and the
  # password salt is used for comparison but the account name and the password itself.
  # 
  # @param [string] name The name of the Account to authenticate
  # @param [string] password The password to authenticate the account with.
  def self.authenticate(name, password)
    account = find_by_name(name, :include => :characters)
    account && account.password == password ?  account : nil
  end
  
  # accessor for the password field. Creates a new BCrypt::Password object out of 
  # the password hash (a string)
  # 
  # @return [BCrypt::Password] the password object
  def password
    @password ||= BCrypt::Password.new(password_hash)
  end
  
  private
  # Encrypt Passoword with BCrypt, do NOT re-encrypt if password is already BCrypt'ed
  # This is to ensure that the user's password does not get changed if his account is altered
  def encrypt_password
    if password.present? and not password.respond_to? :salt
      self.password_hash = BCrypt::Password.create(password)
    end
  end
end
