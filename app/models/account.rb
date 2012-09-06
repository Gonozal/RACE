# The account Class. Holds all information for a user account including
# authentication information (name, password, email address etc).
#
# One Account can have many characters which need to be valid EVE Online
# characters. (see Character) An Account also has only one main_character
class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :main_character_name
  devise :database_authenticatable, :confirmable, :recoverable, :registerable,
    :rememberable, :trackable, :validatable, :lockable

  validates_confirmation_of :email

  has_many :characters, :dependent => :destroy, :include => :roles
  belongs_to :main_character, :class_name => "Character"
end
