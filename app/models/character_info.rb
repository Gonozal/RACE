class CharacterInfo
  # add the default rails logger
  def lo
    gger
    Rails.logger
  end
  
  def skills(api_id, character_id, v_code)
    # Create new API object and assign API-key values
    api = EVEAPI::API.new
    api.api_id = api_id
    api.character_id = character_id
    api.v_code = v_code
    
    begin
      # Get Data for 
      # All Currently learned skills
      skills_xml = api.get("char/CharacterSheet")
      # Skill that is currently being trained
      training_xml = api.get("char/SkillInTraining")
      # total SP on character
      sp_total_xml = api.get("eve/CharacterInfo")
    rescue Exception => e
      puts "EVE API Exception cought!"
      puts e.inspect
    else
      skill_data = Hash.new
      skill_data = skill_hash(skills_xml)
      if training_xml.xpath("/eveapi/result/skillInTraining").text.to_i == 1
        skill_data[:currently_training] = training_xml.xpath("/eveapi/result/trainingTypeID")
      end
      skill_data[:sp_total] = sp_total_xml.xpath("/eveapi/result/skillPoints").text
      return skill_data
    end
  end
  
  def skill_hash(xml)
    # Generate new hashes for later use
    skills_from_api = {}
    skills = { :skills => [], :group_info => Array.new(6) { Hash.new(0) } }
    
    # start by getting all learned skills from the API
    xml.xpath("/eveapi/result/rowset[@name='skills']/row").each do |row|
      skills_from_api[row['typeID']] = { :skill_points => row['skillpoints'], :level =>  row['level'] }
    end
    
    # Query skill names and skill-group names from evedb
    skill_names = InvType.limited.with_groups.find(skills_from_api.keys)
    skill_names.each do |skill|
      # Create new skill object
      logger.warn skill.attributes
      skill.attributes.each do |key, value|
         skill.attributes.delete
      end
    end
      skills[:skills] << Skill.new(skill.attributes.keys.)
      # assign fields not automatically assigned
      s               = skills[:skills].last
      s.level         = Integer skills_from_api[skill.typeID.to_s][:level]
      s.skill_points  = Integer skills_from_api[skill.typeID.to_s][:skill_points]
      s.skill_time_constant = Integer DgmTypeAttribute.find(s.id, 275).valueFloat
      
      # Count up skill group levels
      skills[:group_info][s.level.to_i][s.group_name.to_sym] += 1
      skills[:group_info][s.level.to_i][:all] += 1
    end

    skills[:skills].sort!
    
    skills
  end
end