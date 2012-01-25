class Mailership < ActiveRecord::Base
  belongs_to :character
  belongs_to :mailing_list
end
