class MarketOrder < ActiveRecord::Base
include Comparable

  attr_accessor :transaction_date_time

  belongs_to :corporation
  belongs_to :character

  # Format UNIX Timestampt to EVE-formated datetime string
  # format is: YYYY-MM-DD - hh:mm:ss (24h format)
  def issued_date_time
    Time.at(issued).to_formatted_s(:db)
  end

  # Update Attributes of current MT object from 
  def attributes_from_row (params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    self.issued = Time.parse(params[:issued]).to_i
  end

  # Update Market Orders for all Divisions of provided :owner
  # This is possible for Characters and Corporations
  # TODO: Check if Corp Transactions are handled correctly
  def self.api_update_for(params = {})
    # Create new API object and assign API-related values
    api = EVEAPI::API.new
    api.api_id, api.v_code = params[:owner].api_key.api_id, params[:owner].api_key.v_code
    api.character_id = params[:owner].id

    # Set some basic params for api_update_devision
    params.merge!({
      api: api,
      all_orders: [],
      succesfully_saved: [],
      open_db_orders: {}
    })

    # Go through all Open DB orders and index them in a hash
    params[:owner].market_orders.find_all_by_order_state(0).each do |order|
      params[:open_db_orders][order.order_id]
    end

    if params[:owner].instance_of?(Character)
      # If we are updating Character transactions, go right ahead
      params[:xml_path] = "char/MarketOrders"
      api_update_open_orders(params)
      api_update_closed_orders(params)
    elsif params[:owner].instance_of?(Corporation)
      params[:xml_path] = "corp/MarketOrders"
      api_update_open_orders(params)
      api_update_closed_orders(params)
    else
      # If owner is neither Corporation nor Character, there's nothing we can do
      false
    end

    # We should now have all Transactions stored in params[:all_transactions]
    # Start inserting it and returning the hash with all Transactions
    MarketOrder.transaction do
      params[:all_orders].each do |o|
        # Populate array with succesfully saved transactions
        if o.save
          params[:succesfully_saved] << o
        end
      end
    end
    # Return sucesfully saved Transactions
    params[:succesfully_saved]
  end

  # Update All orders that are oben in EVE ()
  def self.api_update_open_orders(params = {})
    xml = params[:api].get(params[:xml_path])
    # Loop over all Transaction rows supplied by the EVE API
    xml.xpath("/eveapi/result/rowset[@name='orders']/row").each do |row|
      if params[:open_db_orders].has_key? row['orderID']
        # If Order is already in the DB, load it for updates
        mo = params[:open_db_orders].delete(row['orderID'])
        # Update attributes from EVE API data
        mo.attributes_from_row(row)
        params[:all_orders] << mo
      elsif row['orderState'].to_i == 0
        # If we have a new, open order, create it
        mo = params[:owner].market_orders.new
        # Update attributes from EVE API data
        mo.attributes_from_row(row)
        params[:all_orders] << mo
      end
    end
    params[:all_orders].flatten!
  end

  # Updates a (closed) order from the eve API one at a time
  def self.api_update_closed_orders(params = {})
    # All that is left in params[:open_db_orders] are orders, that are now closed
    # We still need to update those (this could take a while..)
    params[:open_db_orders].each do |order|
      params[:api].orderID = order.order_id
      xml.xpath("/eveapi/result/rowset[@name='orders']/row").each do |row|
        mo = params[:open_db_orders].delete(row['orderID'])
        mo.attributes_from_row(row)
        params[:all_orders] << mo
      end
    end
    params[:all_orders].flatten!
  end

  def <=>(other)
    "#{transaction_time}" <=> "#{other.transaction_time}"
  end
end
