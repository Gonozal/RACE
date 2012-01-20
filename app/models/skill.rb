class Skill < ActiveRecord::Base
  include Comparable
  attr_accessor :skill_points_max
  attr_accessor :typeID, :groupID, :valueFloat, :typeName, :groupName
  belongs_to :character

  def data_from_query (obj)
    self.type_id = obj.typeID
    self.group_id = obj.groupID
    self.skill_time_constant = obj.valueFloat
    self.name = obj.typeName
    self.group_name = obj.groupName
  end

  def to_s
    name
  end

  def skill_points_max
    if level == 0
      250 * skill_time_constant
    elsif level == 1
      1415 * skill_time_constant
    elsif level == 2
      8000 * skill_time_constant
    elsif level == 3
      45255 * skill_time_constant
    elsif level >= 4
      256000 * skill_time_constant
    else
      "error"
    end
  end
  
  def <=>(other)
    "#{group_name}#{name}" <=> "#{other.group_name}#{other.name}"
  end
end