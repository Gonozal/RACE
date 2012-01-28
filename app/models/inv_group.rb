class InvGroup < EveData
  self.table_name =  "invGroups"
  self.primary_key = "groupID"
  
  belongs_to :inv_type, :foreign_key => :groupID
  has_one :eve_icon, :foreign_key => :iconID
end
