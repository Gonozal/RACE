class FittingModule < ActiveRecord::Base
  belongs_to :fitting
  has_one :module, class_name: "inv_type", foreign_key: :type_id, primary_key: :typeID
  has_one :charge, class_name: "inv_type", foreign_key: :charge_type_id, primary_key: :typeID
end
