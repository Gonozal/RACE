class CharactersController < ApplicationController
   
  filter_access_to :all
   
   
  def index
    @characters = Character.all
    current_user.update_character_sheet
  end
   
  def show
    @character = CharacterDecorator.decorate current_user
    @skilltree = Skilltree.new current_user.skills
  end
   
  def new
    if current_account.blank?
      redirect_to account_session_url
    else
      @character = Character.new
    end
  end
   
  def create
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
