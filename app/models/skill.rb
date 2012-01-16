class Skill
  include Comparable
  attr_accessor :name, :id, :group_name, :group_id, :level, :skill_points
  
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
  
  def <=>(other)
    "#{group_name}#{name}" <=> "#{other.group_name}#{other.name}"
  end
end