class LogisticsOrderItems < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :logistics_order
  belongs_to :item, class_name: "inv_type", foreign_key: :type_id, primary_key: :typeID

  default_scope includes(:item)

  before_validation :remove_if_empty

  def total_price
    item.price * amount
  end

  private
  # Removes item if amount equals zero 
  # (some users prefer to remove items this way)
  def remove_if_empty
    self.destroy if amount == 0
  end
end
