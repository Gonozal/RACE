class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :instantiate_controller_and_action_names
  helper_method :current_account, :user_nav, :eve_time, :current_user

  private
  # saves the EVE Online time in an instance variable to be accessed i.e. by the view
  def eve_time
    @eve_time ||= Time.now.in_time_zone('Iceland');
  end

  def user_nav
    @user_nav ||= Navigation.new NAV_MODULES
  end 

  # Return current Character of logged in user
  def current_user
    current_account.blank? ? nil : current_account.main_character
  end

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
end
