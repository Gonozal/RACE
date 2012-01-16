class EveIcon < EveData
  set_table_name "eveIcons"
  set_primary_key "iconID"
  
  belongs_to :inv_type, :foreign_key => :iconID
end
