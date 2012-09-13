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
  attr_accessible :email, :email_confirmation, :password, :password_confirmation, :remember_me
  attr_accessor :main_character_name
  devise :database_authenticatable, :confirmable, :recoverable, :registerable,
    :rememberable, :trackable, :validatable, :lockable

  validates_confirmation_of :email

  has_many :characters, :dependent => :destroy, :include => :roles
  belongs_to :main_character, :class_name => "Character"

  # Scopes
  scope :active, lambda { where("last_sign_in_at <= ?", 7.days.ago) }
  scope :inactive, lambda { where("last_sign_in_at > ?", 7.days.ago) }

  # Update and check all active accounts
  def self.api_update_active
    accounts = Account.active.all
    accounts.each do |account|
      account.api_update
    end
  end

  # Update and check all inactive accounts
  def self.api_update_inactive
    accounts = Account.inactive.all
    accounts.each do |account|
      account.api_update
    end
  end

  # Checks if account is still allowed to be active and updates
  # character data if this is the case
  def api_update
    unless authorized?
      return false
    end

    characters.each do |character|
      check_hash = {
        character: 60.minutes,
        skill_queue: 15.minutes,
        eve_asset: 23.hours,
        contract: 15.minutes,
        eve_mail: 30.minuites,
        eve_notification: 30.minutes,
        market_order: 60.minutes,
        wallet_journal: 15.minutes,
        wallet_transaction: 16.minutes
      }

      check_hash.each do |type, time|
        if character.send(:"auto_#{type}_update") and
            character.send(:"last_#{type}_update") < (time + 1.minutes).ago
          type.classify.constantize.api_update_for({ owner: character })
        end
      end
    end
  end

  # Returns true if account is authorized to be used
  # This is the case if a set of conditions is met
  # These can include corp membership, API validity,
  # Alliance membership, paying of monthly fees etc.
  def authorized?
    true
  end
end
