class LogisticsOrderItem < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :logistics_order
  belongs_to :item, class_name: "inv_type", foreign_key: :type_id, primary_key: :typeID

  default_scope includes(:item)

  before_validation :remove_if_empty
  before_validation :locked_if_order_submitted

  def total_price
    item.price * amount
  end

  def total_volume
    item.transport_volume * amount
  end

  private
  # Removes item if amount equals zero 
  # (some users prefer to remove items this way)
  def remove_if_empty
    self.destroy if amount == 0
  end

  # Don't allow changes to the item if parent order is already submitted
  def locked_if_order_submitted
    return false if self.logistics_order.submitted
  end
end
