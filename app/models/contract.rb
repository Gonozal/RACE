class Contract < ActiveRecord::Base
  belongs_to :character, primary_key: :issuer_id, foreign_key: :id
  belongs_to :corporation, primary_key: :issuer_corp_id, foreign_key: :id

  has_many :contract_items, dependent: :destroy
  # Update Attributes of current object from an API row
  def attributes_from_row(params = {})
    # Try to do as much as possible automated
    params.each do |key, val|
      key = key.to_s.underscore
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    send(:contract_type=, params['type'])
    send(:id=, params['contractID'])
  end

  # Update contracts from the eve API
  def self.api_update(params = {})
    # create new API object
    api = set_api(params)
    new_contracts = {}
    params[:path] = api_path(params[:owner])

    # Get all existing contracts from this owner
    db_contracts = existing_contracts(params[:owner])

    begin
      # get mail headers XML
      xml = api.get(params[:path] + "Contracts")
    rescue Exception => e
      puts e.inspect
    else
      xml.xpath("/eveapi/result/rowset[@name='contractList']/row").each do |row|
        # If Contract is already in DB, load it. Otherwise create new contract
        new_contracts.merge!(contract_from_api(row, db_contracts, params[:owner], params[:path], api))
      end
    end
    save_contracts new_contracts
  end


  private
  # Saves all contracts using a transaction
  def self.save_contracts(new_contracts)
    unless new_contracts.empty?
      # Insert contracts into DB
      Contract.transaction do
        new_contracts.each_value do |contract|
          contract.save
        end
      end
    end
  end

  # Get a list of all contracts of the owner from the DB within the last 2 months
  def self.existing_contracts(owner)
    contracts = {}
    db_contracts = owner.contracts.all
    db_contracts += owner.assigned_contracts.all
    db_contracts.each do |contract|
      contracts[contract.id.to_s] = contract
    end  
    logger.warn contracts
    contracts
  end

  # Create contract if it did not exist in DB / load from DB hash otherwise
  def self.contract_from_api(row, db_contracts, owner, api_path, api)
    new_contracts = {}
    if db_contracts.has_key?(row['contractID'])
      c = db_contracts[row['contractID']]
    else
      c = Contract.new
      # Unless contract is courier contract, get contained items
      unless c.contract_type == "Courier"
        api.contract_id = row['contractID'].to_i
        begin
          xml = api.get(api_path + "ContractItems")
          logger.warn xml
        rescue Exception => e
          puts e.inspect
        else
          # Add items to contract
          logger.warn "item_rows"
          xml.xpath("/eveapi/result/rowset[@name='itemList']/row").each do |row|
            logger.warn row
            ci = c.contract_items.new
            ci.update_fom_row(row)
          end
        end
      end
    end
    # update contract attributes
    c.attributes_from_row(row)

    # Save Contract in hash so we can easily check if it's already in the DB
    new_contracts[c.id.to_s] = c
    new_contracts
  end


  # Sets API object with required attributes
  def self.set_api(params = {})
    api = EVEAPI::API.new
    api.api_id = params[:owner].api_id
    api.v_code = params[:owner].v_code
    api.character_id = params[:owner].id
    api
  end
  
  # Decide API path (/char/ or /corp/) from :owner class
  def self.api_path(owner)
    # Get the proper path according to owner's Class
    if owner.instance_of?(Character)
      "/char/"
    elsif owner.instance_of?(Corporation)
      "/corp/"
    else
      false
    end
  end
end
