class InvType < EveData
  self.table_name = 'invTypes'
  self.primary_key = 'typeID'
  
  has_one :inv_group, :foreign_key => :groupID, :primary_key => :groupID
  has_one :eve_icon, :foreign_key => :iconID, :primary_key => :iconID
  has_many :dgm_type_attributes, :foreign_key => :typeID
  has_one :market_price, :foreign_key => :typeID, :primary_key => :type_id, :conditions => "character_id = 0"
  
  scope :limited, select("invTypes.typeID, invTypes.groupID, invTypes.typeName, invTypes.marketGroupID, invTypes.iconID")
  # scope :with_groups, joins("INNER JOIN invGroups ON invGroups.groupID = invTypes.groupID").select("invGroups.groupName")
  scope :with_groups, joins(:inv_group).select("invGroups.groupName")
  scope :with_icons, joins(:eve_icon)
  scope :with_skill_attributes, joins(:dgm_type_attributes).where(:dgmTypeAttributes => {:attributeID => 275}).select("dgmTypeAttributes.*")

  def price
    if market_price.price
      market_price.price
    else
      basePrice
    end
  end

  def transport_volume
    # Repackaged volumes of ships need to be set manually
    vol = Hash.new
    vol[500] = [29, 31] #Capsule, Shuttle
    vol[1000] = [12, 340, 448, 649, 952] #Container
    vol[2500] = [25, 237, 324, 830, 831, 834] # Frigate Hulls
    vol[3750] = [463, 543] # Mining Hulls
    vol[5000] = [420, 541, 963] # Destroyer Hulls / Strategic Cruiser
    vol[10000] = [26, 358, 832, 833, 894, 906] # Cruiser Hulls
    vol[15000] = [419, 540] # Battlecruiser Hulls
    vol[20000] = [28, 380] # Industrial Hulls
    vol[25000] = [873] # Electronic Attack Ships
    vol[50000] = [27, 381, 898, 900] # Battleship Hulls
    vol[500000] = [941] # Industrial Command Ships
    vol[1000000] = [485, 513, 547, 883, 902] # Capitals
    vol[10000000] = [30, 659] # Super Capitals

    # Traverse hash and return repackaged value if applicable
    vol.each do |v|
      return v.first.to_i if v[1].include?(groupID)
    end
    # Return standard value otherwise
    volume
  end

end
