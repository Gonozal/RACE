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

end
