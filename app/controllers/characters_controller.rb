class CharactersController < ApplicationController
   
  filter_access_to :all
   
   
  def index
    @characters = Character.all
  end
   
  def show
    @character = current_account.characters.all
  end
   
  def new
    if current_account.blank?
      redirect_to login_url
    else
      @character = Character.new
    end
  end
   
  def create
    @errors = { :alert => Array.new, :notice => Array.new }
    user_id, api_key = params['character']['user_id'], params['character']['api_key']
    character_ids = params['character']['character_ids'];
    begin
      @characters = Character.find_by_api!(user_id, api_key)
    rescue Exception => e
      @errors[:alert] = e.message
      # logger.warn e.backtrace.to_yaml
    # If user has choosen his characters, check for legitimacy
    # (prevent forging character names) and try to register those characters
    else
      if character_ids.blank?
        # if there are characters found for his API data, but he has not chosen
        # any as of now, display character selection boxes
        render "expand_characters", :locals => { :all_characters => Character.select(:name).all.map { |c| c.name } }
        return
      else
        # Get a list of all characters to disable ones that are already registered
        # Register characters
        @characters = @characters.select{ |c| character_ids.include? c[:character_id]}
        if @characters.present?
          @new_characters = Array.new
          @characters.each do |c|
            # Go through each character and add it to his account
            if @character = current_account.characters.create(c)
              @new_characters << @character
            else
              @errors[:alert] = "Registration of character #{self.name} failed."
            end
          end
          current_account.main_character_id = @character.id
          current_account.save
          render "create"
          return
        end
      end
    end
    render "update"
  end
   
   # Manage API data of all characters registered to the account
  def edit
    @characters = current_account.characters.all
  end
   
  # Updates all characters belonging to the current account
  # It is also possible to delete characters with this method
  # This is because arbitrary seperation of "edit" and "delete"
  # is kinda pointless in this case
  def update
    # Create instance variables that can be accessed by the views
    @characters = current_account.characters.all
     
    @characters.each do |c|
      c.user_id = params[:user_id][c.character_id.to_s]
      c.api_key = params[:api_key][c.character_id.to_s]
      if params[:delete][c.character_id.to_s].eql? c.name
        # If user confirmed char deletion with the characters name, delete it
        c.destroy
        c.errors.add :success, "Character #{c.name} succesfully deleted"
      elsif not (c.user_id_changed? or c.character_id_changed?)
        # Do nothing if nothing was changed
        c.errors.add :notice, "API data for #{c.name} did not change"
      # Validate the API bevore trying to save it
      elsif c.valid_api? and c.save!
        c.errors.add :success, "API data for #{c.name} succesfully updated"
      else
        # Display error if API data was bogus
        c.errors.add :alert, "Character could not be saved. Please check your API data"
      end
    end
  end
   
  def destroy
    # @character = Character.find(params[:id])
    # @character.destroy
  end
   
  def select
    new_character
  end
   
  def permission_denied
    render "application/access_denied.html.slim"
  end
end