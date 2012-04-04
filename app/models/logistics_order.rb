class LogisticsOrder < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :logistics_order_items
  has_many :items, class_name: "inv_type", foreign_key: :type_id, primary_key: :typeID, through: :logistics_order_items
end
