class CharactersController < ApplicationController
   
  filter_access_to :all
   
   
  def index
    @characters = Character.all
    current_user.update_character_sheet
  end
   
  def show
    @character = current_account.characters.all
  end
   
  def new
    if current_account.blank?
      redirect_to account_session_url
    else
      @character = Character.new
    end
  end
   
  def create
    @errors = { :alert => Array.new, :notice => Array.new }
    api_id, v_code = params['character']['api_id'], params['character']['v_code']
    ids = params['character']['character_ids']
    begin
      @characters = Character.find_by_api!(api_id, v_code)
    rescue Exception => e
      @errors[:alert] = e.message
      logger.warn e.backtrace.to_yaml
    # If user has choosen his characters, check for legitimacy
    # (prevent forging character names) and try to register those characters
    else
      if ids.blank?
        # if there are characters found for his API data, but he has not chosen
        # any as of now, display character selection boxes
        render "expand_characters", :locals => { :all_characters => Character.select(:name).all.map { |c| c.name } }
        return
      else
        # Get a list of all characters to disable ones that are already registered
        # Register characters
        @characters = @characters.select{ |c| ids.include? c[:id]}
        if @characters.present?
          @new_characters = Array.new
          @characters.each do |c|
            # Go through each character and add it to his account
            @character = current_account.characters.new(c)
            @character.id = c[:id]
            a = ApiKey.new(api_id: api_id, v_code: v_code)    
            if @character.save and a.save
              @character.api_key_id = a.id
              @character.save
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
      c.api_key.api_id = params[:api_id][c.id.to_s]
      c.api_key.v_code = params[:v_code][c.id.to_s]
      if params[:delete][c.id.to_s].eql? c.name
        # If user confirmed char deletion with the characters name, delete it
        c.destroy
        c.errors.add :success, "Character #{c.name} succesfully deleted"
      elsif not(c.api_key.v_code_changed? or c.api_key.api_id_changed?)
        # Do nothing if nothing was changed
        c.errors.add :notice, "API data for #{c.name} did not change"
      # Validate the API bevore trying to save it
      elsif c.valid_api? and c.api_key.save!
        c.errors.add :success, "API data for #{c.name} succesfully updated"
      else
        # Display error if API data was bogus
        c.errors.add :alert, "Character could not be saved. Please check your API data"
      end
      c.errors.each do |error|
        logger.warn error
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
