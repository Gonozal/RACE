class Skill
  include Comparable
  attr_accessor :name, :id, :group_name, :group_id, :level, :skill_points, :skill_points_max, :skill_time_constant
  
  # add the default rails logger
  def logger
    Rails.logger
  end
  
  def initialize(params = {})
    params.stringify_keys!
    
    params.each do |key, val|
      key = key.underscore.gsub /^type_/, ''
      if respond_to?(:"#{key}=")
        send(:"#{key}=", val)
      end
    end
    self
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