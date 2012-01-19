class DgmTypeAttribute < EveData
  set_table_name "dgmTypeAttributes"
  set_primary_keys :typeID, :attributeID
  
  belongs_to :inv_type, :foreign_key => :typeID
  has_one :dgm_attribute_type, :foreign_key => :attributeID
end
