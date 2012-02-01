class Skilltree
  attr_reader :groups
  attr_accessor :skill_points, :lvl5s, :lvl5_skill_points

  def initialize(skills)
    @skill_points = 0
    @lvl5s = 0
    @lvl5_skill_points = 0

    group_name = ""
    @groups = []

    skills.sort.each do |skill|
      group = add_group(skill.group_name)
      group << skill
      @skill_points += skill.skill_points

      if skill.level == 5
        @lvl5s += 1
        @lvl5_skill_points += skill.skill_points
      end
    end
  end

  private
  def last_group_name
    @last_group_name ||= ""
  end

  def add_group(name)
    @groups << Group.new(name) unless name == last_group_name
    @last_group_name = name
    @groups.last
  end

  class Group
    attr_reader :skills, :name
    attr_accessor :skill_points, :lvl5s, :lvl5_skill_points

    def initialize(name)
      @name = name
      @skill_points = 0
      @lvl5s = 0
      @lvl5_skill_points = 0
      @skills = []
    end

    def << skill
      @skills << skill
      @skill_points += skill.skill_points
      if skill.level == 5
        @lvl5s += 1
        @lvl5_skill_points += skill.skill_points
      end

      @skills
    end
  end
end
