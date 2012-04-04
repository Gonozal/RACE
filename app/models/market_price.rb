class MarketPrice < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :character
  belongs_to :item, class_name: "inv_type", foreign_key: :type_id, primary_key: :typeID

end
