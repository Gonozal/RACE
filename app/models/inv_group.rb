class InvGroup < EveData
  set_table_name "invGroups"
  set_primary_key "groupID"
  
  belongs_to :inv_type, :foreign_key => :groupID
  has_one :eve_icon, :foreign_key => :iconID
end
