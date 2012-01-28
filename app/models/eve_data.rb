class EveData < ActiveRecord::Base
  establish_connection :eve_development
  self.table_name = 'invTypes'
  self.primary_key = 'typeID'
end
