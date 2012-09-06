# The account Class. Holds all information for a user account including authentication
# information (name, password, email address etc).
#
# One Account can have many characters which need to be valid EVE Online characters. (see Character)
# An Account also has only one main_character
class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :main_character_name
  # Hash password
  attr_accessible :name, :email, :email_confirmation, :password, :password_confirmation

  has_secure_password

  validates_uniqueness_of   :name
  validates_format_of       :name, with: /^\w[\w\d ]+$/
  validates_length_of       :name, within: 3..24

  validates_presence_of     :password, on: :create
  validates_length_of       :password, minimum: 5, on: :create

  validates_uniqueness_of   :email
  validates_format_of       :email, with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_confirmation_of :email

  has_many :characters, :dependent => :destroy, :include => :roles
  belongs_to :main_character, :class_name => "Character"

  # Authenticate user with name and password
  def self.authenticate(name, password)
    account = find_by_name(name)
    return account if account and account.authenticate password
  end

  private
  def generate_token(columns)
    columns = [] << columns unless columns.is_a?(Array)
    columns.each do |column|
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while Account.exists?(column => self[column])
    end
  end
end
