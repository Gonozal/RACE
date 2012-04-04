class LogisticsOrder < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :logistics_order_items
  has_many :items, class_name: "inv_type", foreign_key: :type_id, primary_key: :typeID, through: :logistics_order_items

  before_save :validate_before_submit

  # Gross Price. Only the item price, no fees
  def gross_price
    price = 0
    logistics_order_items.each do |i|
      price += i.total_price
    end
  end

  # Volume of all items in the order
  def total_volume
    volume = 0
    logistics_order_items.each do |i|
      volume += i.total_volume
    end
  end

  # Various Fees that can be adjusted by the postman
  def unique_items_fee
    logistics_order_items.count * 30000
  end

  def per_volume_fee
    total_volume * 100
  end

  def per_order_fee
    100000
  end

  def percentage_fee
    gross_price * 0.02
  end

  def total_fees
    unique_items_fee + per_volume_fee + per_order_fee + percentage_fee
  end

  def net_price
    gross_price + total_fees
  end 

  # Add new item to order
  def add_item(type_id, amount = 1)
    # Don't allow changes if order is submitted
    return false if submitted

    # Try to find an existing product first
    current_item = logistics_order_items.detect do |item|
      item.type_id.to_i == type_id.to_i
    end
    # If item already exists, increase amount. Otherwise: add new item
    if current_item
      current_item.amount += amount
    else
      current_item = logistics_order_items.build(:type_id => type_id)
    end

    current_item
  end

  # Fail validation if order is being submitted but has no items or no destination
  def validate_before_submit
    !( !!submitted and submitted_changed? and (logisics_order_items.count == 0 or !destination_id))
  end

end
