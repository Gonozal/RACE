class Fitting < ActiveRecord::Base
  has_many :fitting_modules, :include => [:module, :charge]
  belongs_to :character
end
