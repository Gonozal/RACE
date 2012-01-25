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

    xml = api.get(params[:xml_path]).xpath("/eveapi/result")

    assets = [[]]
    assets.last[0] = params[:owner]
    assets.last[1] = xml

    # If row contains a rowset, recursivle add elements
    while true do
      new_level = false
      new_assets = []
      assets.each do |asset|
        unless asset[1].blank?
          new_assets += api_update_ancestor(asset[0], asset[1])
          new_level = true
        end
      end

      EveAsset.transaction do
        new_assets.map { |a| a[0].save }
      end

      assets = new_assets
      break unless new_level
    end
  end

  def self.api_update_ancestor(root, rows)
    # Loop over all rows in the provided array of rows
    list = []
    rows.each do |row|
      list << []
      # Create eve_child_asset as child of root
      if root.respond_to?("eve_assets")
        asset = root.eve_assets.new
        asset.attributes_from_row(row)
      else
        asset = root.children.new
        asset.attributes_from_row(row)
        # Set Assets character_id XOR corporation_id the same as parent asset's
        asset.character_id = root.character_id
        asset.corporation_id = root.corporation_id
      end
      # We need to save now so we can reference the element later on
      list.last[0] = asset
      list.last[1] = row.xpath "./rowset/row"
    end
    list
  end
end
