class InvType < EveData
  set_table_name "invTypes"
  set_primary_key "typeID"
  
  has_one :inv_group, :foreign_key => :groupID, :primary_key => :groupID
  has_one :eve_icon, :foreign_key => :iconID, :primary_key => :iconID
  
  scope :limited, select("invTypes.typeID, invTypes.groupID, invTypes.typeName, invTypes.marketGroupID, invTypes.iconID")
  # scope :with_groups, joins("INNER JOIN invGroups ON invGroups.groupID = invTypes.groupID").select("invGroups.groupName")
  scope :with_groups, joins(:inv_group).select("invGroups.groupName")
  scope :with_icons, joins(:eve_icon)
end
