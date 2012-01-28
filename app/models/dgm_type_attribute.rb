class DgmTypeAttribute < EveData
  self.table_name = "dgmTypeAttributes"
  self.primary_key = "typeID"
  
  belongs_to :inv_type, :foreign_key => :typeID
  has_one :dgm_attribute_type, :foreign_key => :attributeID
end
