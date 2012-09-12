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
    if authorized?
      characters.each do |character|
        params = { owner: character }
        if character.auto_character_sheet_update and character.last_character_sheet_update < 61.minutes.ago
          character.update_character_sheet
        end
        if character.auto_skill_queue_update and character.last_skill_queue_update < 16.minutes.ago
          SkillQueue.api_update_for(params)
        end
        if character.auto_asset_update and character.last_asset_update < (23.hours + 1.minutes).ago
          Eve_Asset.api_update_for(params)
        end
        if character.auto_cpntract_update and character.last_contract_update < 16.minutes.ago
          Contract.api_update_for(params)
        end
        if character.auto_mail_update and character.last_mail_update < 31.minutes
          EveMail.api_update_for(params)
        end
        if character.auto_notification_update and character.last_notification_update < 31.minutes
          EveNotification.api_update_for(params)
        end
        if character.auto_market_order_update and character.last_market_order_update < 61.minutes
          MarketOrder.api_update_for(params)
        end
        if character.auto_wallet_journal_update and character.last_wallet_journal_updat < 16.minutes
          WalletJournal.api_update_own(params)
        end
        if character.auto_wallet_transaction_update and character.last_wallet_transaction_update < 16.minutes
          WalletTransaction.api_update_own(params)
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
