class SkillsController < ApplicationController
  # GET /skills
  # GET /skills.json
  def index
    skills = {}
    SkillQueue.api_update(owner: current_user)
    # Get all Skills
    skills = current_user.skills.all
    if skills.length == 0
      # If user has no registered skills, update and reload them
      Skill.api_update_own(current_user)
      skills = current_user.skills.all
    end

    @skilltree = Skilltree.new skills
    @skill_in_training = current_user.skill_in_training
  end
end
