class EveMail < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :corporation
  belongs_to :mailing_list

  has_and_belongs_to_many :characters
end
