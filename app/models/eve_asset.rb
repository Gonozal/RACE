class EveAsset < ActiveRecord::Base
  has_ancestry
  has_paper_trail

  # Update Attributes of current MT object from 
  def attributes_from_row(params = {})
    self.flag = params['flag']
    self.item_id = params['itemID']
    self.location_id = params['locationID']
    self.quantity = params['quantity']
    self.raw_quantity = params['rawQuantity']
    self.singleton = params['singleton']
    self.type_id = params['typeID']
  end

  # Update all Assets for a single Entity. 
  # Procedure for now: Delete all current assets and insert them from the API
  # This should be faster than reading all entries, comparing them to API assets
  # and then updating/inserting/deleting entries
  def self.api_update_own(params = {})
    # We need to be able to access the owner pretty much anywhere
    @owner = params[:owner]
    # Create new API object and assign API-related values
    api = EVEAPI::API.new
    api.api_id, api.v_code = @owner.api_key.api_id, @owner.api_key.v_code
    api.character_id = @owner.id

    # get Asset XML from API (or cache)
    xml = api.get(xml_path_for(@owner))

    # Create assets hash with entries for arrays that'll be filled
    assets = { new: [], old: {} }

    # Get all existing assets for the user in order to decide
    # if eve_asset/eve_asset_from_xml  has to be updated, destroyed or created
    old_assets = @owner.eve_assets.scoped.all()

    # Iterate over old_assets and save it in an {item_id: EveAsset} hash
    old_assets.each do |old_asset|
      assets[:old][old_asset.item_id] = old_asset
    end

    assets[:unparsed] = xml.xpath("/eveapi/result/rowset[@name='assets']/row")

    # Parse assets from XML
    assets = api_parse_rowset(assets)

    # Flatten array
    assets[:new].flatten!

    # Save Assets inside of Transaction to save some time through mass inserts
    EveAsset.transaction do
      assets[:new].each do |asset|
        asset.save
      end
    end
    # Now delete all the old assets that are still in the old_assets hash
    EveAsset.transaction do
      assets[:old].each do |id, asset|
        asset.destroy
      end
    end
  end

  def set_reference_id(owner)
    if owner.instance_of?(Character)
      self.character_id = owner.id
    elsif owner.instance_of?(Corporation)
      self.corporation_id = owner.id
    else
      raise ArgumentError, "Assets can only be retrieved for Characters or Corporations"
    end
  end

  def self.xml_path_for(object)
    # Query character or corp assets depending on owner
    if object.instance_of?(Character)
      "char/AssetList"
    elsif object.instance_of?(Corporation)
      "corp/AssetList"
    else
      raise ArgumentError, "Assets can only be retrieved for Characters or Corporations"
    end
  end


  def self.api_parse_rowset(assets)
    # Reset new asset array
    assets[:new] = []
    # Define new_assets hash to make adding elements easier
    assets[:unparsed].each do |row|
      # skip element if it is empty
      next if row.blank?
      # If asset already exists, load it and remove entry from hash
      # Else create new asset
      if assets[:old].key? row['itemID'].to_i
        asset = assets[:old][row['itemID'].to_i]
        assets[:old].delete(row['itemID'].to_i)
      else
        asset = EveAsset.new
      end
      # Set ancestry and let attributes_from_row handle the rest
      asset.parent = assets[:parent] if assets[:parent].present?
      asset.attributes_from_row(row)
      asset.set_reference_id(@owner)
      # If asset functions as container, do recursion
      # otherwise add asset to array to be saved later
      child_rows = row.children.children
      if child_rows.present?
        # We need to save the asset now so we can perform tree ancestry operations
        asset.save if asset.changed?
        # Recursively add child elements
        child_hash = { parent: asset, unparsed: child_rows, old: assets[:old] }
        recursion_hash = api_parse_rowset(child_hash)
        assets[:new] << recursion_hash[:new]
        assets[:old] = recursion_hash[:old]
      else
        # add asset to new assets array
        assets[:new] << asset
      end
    end
    assets
  end
end
