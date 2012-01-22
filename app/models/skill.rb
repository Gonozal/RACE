class Skill < ActiveRecord::Base
  include Comparable
  attr_accessor :skill_points_max
  attr_accessor :typeID, :groupID, :valueFloat, :typeName, :groupName
  belongs_to :character

  def attributes_from_object (obj)
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

  # Update current character's skills
  def self.api_update_own(character)
    skills = []
    # Get new and updated skills from EVE API

    # Create new API object and assign API-key values
    api = EVEAPI::API.new
    api.api_id = character.api_id
    api.id = character.id
    api.v_code = character.v_code

    begin
      # Get Data for all Currently learned skills
      xml = api.get("char/CharacterSheet")
    rescue Exception => e
      puts e.inspect
    else
      # Generate new hashes for later use
      skills_from_api = {}
      old_skills = {}

      # start by getting all learned skills from the API0
      xml.xpath("/eveapi/result/rowset[@name='skills']/row").each do |row|
        skills_from_api[row['typeID']] = { :skill_points => row['skillpoints'], :level =>  row['level'] }
      end

      # Query skill names and skill-group names from evedb
      skill_names = InvType.limited.with_groups.with_skill_attributes.find(skills_from_api.keys)
      # Get already existing skills and save them in a Hash
       Skill.find_all_by_character_id(character.id).each do |s|
        old_skills[s.type_id.to_s] = s
      end
    end
    # Iterate over all Skills retrieved from the API
    skill_names.each do |skill|
      if(old_skills.has_key? skill.typeID.to_s)
        # If skill is already in DB, don't create a new one but load existing skill object
        s = old_skills[skill.typeID.to_s]
      else
        # else, create new skill Object
        s = character.skills.new
        # Quick and dirty assignment of skill data according to eve SDE data
        s.attributes_from_object(skill)
        s.skill_time_constant = Integer skill.valueFloat
      end
      # Update variable skill data with (potentially) new values
      s.level         = Integer skills_from_api[skill.typeID.to_s][:level]
      s.skill_points  = Integer skills_from_api[skill.typeID.to_s][:skill_points]
      # Add skill and currently training skill to array
      skills << s
    end

    Skill.transaction do
      skills.each do |s|
        s.save
      end
    end
  end

  # Get new and updated skills from EVE API for ALL characters
  def self.api_update_all

    # Generate new hashes for later use
    skills, skill_ids, api_skill_data, old_skills = [], [], {}, {}
  
    # Get all characters
    characters = Character.all
    characters.each do |c|
      api_skill_data[c.id.to_s], old_skills[c.id.to_s] = {:character => c, :skills => {}}, {}
      # Create new API object and assign API-key values
      api = EVEAPI::API.new
      api.api_id = c.api_id
      api.v_code = c.v_code
      api.id = c.id
        
      begin
        # Get Data for all Currently learned skills
        xml = api.get("char/CharacterSheet")
      rescue Exception => e
        puts e.inspect
      else
        # start by parsing all learned skills from the API
        xml.xpath("/eveapi/result/rowset[@name='skills']/row").each do |row|
          api_skill_data[c.id.to_s][:skills][row['typeID']] = { :skill_points => row['skillpoints'], :level =>  row['level'] }
          skill_ids << (Integer row['typeID'])
        end
      end
    end
    # Create on list of all learned skill IDs for DB query
    skill_ids = skill_ids.flatten.uniq

    # Get allready existing skills and save them in a 2D-hash
    Skill.all.each do |s|
      old_skills[s.id.to_s][s.type_id.to_s] = s
    end
    
    # Query skill names and skill-group names from evedb
    skill_names = {}
    InvType.limited.with_groups.with_skill_attributes.find(skill_ids).each do |skill|
      skill_names[skill.typeID.to_s] = skill
    end

    # Iterate over previously created hash containing API skill data
    api_skill_data.each do |c_id, char_data|
      char_data[:skills].each do |type_id, skill|
        skill_name = skill_names[type_id.to_s]
        if(old_skills[c_id.to_s].has_key? type_id.to_s)
          # If skill is already in DB, don't create a new one but load existing skill object
          s = old_skills[c_id.to_s][type_id.to_s]
        else
          # else, create new skill Object
          s = char_data[:character].skills.new
          # Quick and dirty assignment of skill data according to eve SDE data
          s.attributes_from_object(skill_name)
          s.skill_time_constant = Integer skill_name.valueFloat
        end
        # Update variable skill data with (potentially) new values
        s.level         = Integer skill[:level]
        s.skill_points  = Integer skill[:skill_points]
        # Add skill and currently training skill to array
        skills << s
      end
    end

    # Save all processed skills
    Skill.transaction do
      skills.each do |s|
        s.save
      end
    end
  end






  ## Benchmurk function, to be removed!
  def self.api_update_all_benchmark
    
    # Create a bunch of fake accounts
    (1..100).each do |i|
      Account.first.characters.create(name: "Test_#{i}", 
                                      api_id: 539347, 
                                      v_code: "fiK6Jl3WZBqDI3DWDKHEWZz4ucIc69F1QxmfykmpJ1AZYYT9TBpavy39WCREnzeK",
                                      character_id: 1175431904,
                                      corporation_name: "The Scope",
                                      corporation_id: 1000107)
    end


    # Delete all skills
    Skill.transaction do
      Skill.all.each do |s|
        s.destroy
      end
    end
    # Begin "iterate over all cahracters" testrun
    time1_1 = Time.now
    Character.all.each do |c|
      Skill.api_update_own(c)
    end
    time1_2 = Time.now - time1_1

    # Delete all skills
    Skill.transaction do
      Skill.all.each do |s|
        s.destroy
      end
    end

    # Begin "do less queries" testrun
    time2_1 = Time.now
    Skill.api_update_all
    time2_2 = Time.now - time2_1


    # Just updateing:
    time3_1 = Time.now
    Character.all.each do |c|
      Skill.api_update_own(c)
    end
    time3_2 = Time.now - time3_1

    time4_1 = Time.now
    Skill.api_update_all
    time4_2 = Time.now - time4_1

    # clean up data
    Character.where('"name" LIKE "Test_%"').destroy_all



    # compare times
    puts "Elapsed time Method1 NEW skills: #{time1_2} seconds"
    puts "Elapsed time Method2 NEW skills: #{time2_2} seconds"
    puts "Elapsed time Method1 UPDATING skills: #{time3_2} seconds"
    puts "Elapsed time Method2 UPDATING skills: #{time4_2} seconds"
  end
end