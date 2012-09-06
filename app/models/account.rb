# The account Class. Holds all information for a user account including
# authentication information (name, password, email address etc).
#
# One Account can have many characters which need to be valid EVE Online
# characters. (see Character) An Account also has only one main_character
class Account < ActiveRecord::Base
  attr_accessor :main_character_name
  devise :database_authenticatable, :confirmable, :recoverable, :registerable,
    :rememberable, :trackable, :vaidateable, :lockable

  has_many :characters, :dependent => :destroy, :include => :roles
  belongs_to :main_character, :class_name => "Character"
end
