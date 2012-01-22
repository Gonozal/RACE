class SkillsController < ApplicationController
  # GET /skills
  # GET /skills.json
  def index
    @skills = {}
    # Get all Skills
    @skills[:skills] = current_user.skills.all
    if @skills[:skills].length == 0
      # If user has no registered skills, update and reload them
      Skill.api_update_own(current_user)
      @skills[:skills] = current_user.skills.all
    end
    @skills[:skills].sort!
    @skills[:training] = current_user.skill_in_training
  end
end
