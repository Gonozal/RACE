class EveData < ActiveRecord::Base
  establish_connection "eve_development"
end
