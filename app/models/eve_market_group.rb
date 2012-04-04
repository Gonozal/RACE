class InvMarketGroup < EveData
  self.table_name =  "invMarketGroups"
  self.primary_key = "marketGroupID"
  
  belongs_to :inv_type, :foreign_key => :marketGroupID
  has_one :eve_icon, :foreign_key => :iconID

  scope :root_groups, where(parentGroupID: nil)
end
