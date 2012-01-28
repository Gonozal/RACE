class EveIcon < EveData
  self.table_name = "eveIcons"
  self.primary_key = "iconID"
  
  belongs_to :inv_type, :foreign_key => :iconID
end
