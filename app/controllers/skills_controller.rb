class SkillsController < ApplicationController
  # GET /skills
  # GET /skills.json
  def index
    # Get new and updated skills from EVE API

    # Create new API object and assign API-key values
    api = EVEAPI::API.new
    api.api_id = current_user.api_id
    api.character_id = current_user.character_id
    api.v_code = current_user.v_code

    begin
      # Get Data for all Currently learned skills
      skills_xml = api.get("char/CharacterSheet")
      # Skill that is currently being trained
      training_xml = api.get("char/SkillInTraining")
    rescue Exception => e
      puts e.inspect
    else
      # Generate new hashes for later use
      skills_from_api = {}
      old_skills = {}
      @skills = { :skills => []}

      # start by getting all learned skills from the API
      skills_xml.xpath("/eveapi/result/rowset[@name='skills']/row").each do |row|
        skills_from_api[row['typeID']] = { :skill_points => row['skillpoints'], :level =>  row['level'] }
      end

      # Query skill names and skill-group names from evedb
      skill_names = InvType.limited.with_groups.with_skill_attributes.find(skills_from_api.keys)
      # Get already existing skills and save them in a Hash
       Skill.find_all_by_character_id(current_user.id).each do |s|
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
        s = current_user.skills.new
        # Quick and dirty assignment of skill data according to eve SDE data
        s.data_from_query(skill)
        s.skill_time_constant = Integer skill.valueFloat
      end
      # Update variable skill data with (potentially) new values
      s.level         = Integer skills_from_api[skill.typeID.to_s][:level]
      s.skill_points  = Integer skills_from_api[skill.typeID.to_s][:skill_points]
      # Add skill and currently training skill to array
      @skills[:skills] << s
      if training_xml.xpath("/eveapi/result/skillInTraining").text.to_i == 1
        @skills[:currently_training] = training_xml.xpath("/eveapi/result/trainingTypeID")
      end
    end

    Skill.transaction do
      @skills[:skills].each do |s|
        s.save
      end
    end
    # Sort skill array (Sort by skill category & name)
    @skills[:skills].sort!
  end
end
