class Mailership < ActiveRecord::Base
  set_primary_keys :character_id, :mailing_list_id
  belongs_to :character
  belongs_to :mailing_list
end
