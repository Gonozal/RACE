class EveAsset < ActiveRecord::Base
  has_ancestry

  # Update Attributes of current MT object from 
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
  end

  # Update all Assets for a single Entity. 
  # Procedure for now: Delete all current assets and insert them from the API
  # This should be faster than reading all entries, comparing them to API assets
  # and then updating/inserting/deleting entries
	def self.api_update_own(params = {})
    # Create new API object and assign API-related values
    api = EVEAPI::API.new
    api.api_id, api.v_code = params[:owner].api_id, params[:owner].v_code
    api.character_id = params[:owner].id

    # Delete all assets for the Owner, delete_all isntead of destroy_all because
    # we don't need to take care of relations and it's much faster this way
    params[:owner].eve_assets.scoped.delete_all()
   
    if params[:owner].instance_of?(Character)
      # If we are updating Character journals, go right ahead
      params[:xml_path] = "char/AssetList"
    elsif params[:owner].instance_of?(Corporation)
      params[:xml_path] = "corp/AssetList"
    else
      # If owner is neither Corporation nor Character, there's nothing we can do
      return false
    end
    xml = api.get(params[:xml_path])

    # Loop over all journal rows supplied by the EVE API
    time = Time.now
    xml.xpath("/eveapi/result/rowset[@name='assets']/row").each do |row|
      eve_root_asset = params[:owner].eve_assets.new
      eve_root_asset.attributes_from_row(row)
      # We need to save now so we can reference the element later on
      eve_root_asset.save
      # If row contains a rowset, recursivle add elements
      unless row.children.blank?
        api_update_ancestor(eve_root_asset, row.xpath("./rowset[@name='contents']/row"))
      end
    end
    logger.warn "Assets Parsing Time: #{Time.now - time}"
  end

  def self.api_update_ancestor(eve_root_asset, rows)
    # Loop over all rows in the provided array of rows
    rows.each do |row|
      # Create eve_child_asset as child of eve_root_asset
      eve_child_asset = eve_root_asset.children.new
      eve_child_asset.attributes_from_row(row)
      # Set Assets character_id XOR corporation_id the same as parent asset's
      eve_child_asset.character_id = eve_root_asset.character_id
      eve_child_asset.corporation_id = eve_root_asset.corporation_id
      # We need to save now so we can reference the element later on
      eve_child_asset.save
      # If eve_child_asset contains another rowset, recursivle add those
      unless row.xpath("./rowset/row").blank?
        api_update_ancestor(eve_child_asset, row.xpath("./rowset/row"))
      end
    end
  end
end
