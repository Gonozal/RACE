class ApplicationController < ActionController::Base
  
  protect_from_forgery
  helper_method :current_user, :current_account, :user_nav, :eve_time
  
  
  private
  # saves the EVE Online time in an instance variable to be accessed i.e. by the view
  def eve_time
    @eve_time ||= Time.now.in_time_zone('Iceland');
  end

  # Return current Character of logged in user
  def current_user
    current_account.blank? ? nil : current_account.main_character
  end
  
  # Return Account Character of logged in user
  def current_account
    @current_account ||= Account.authenticated_with_token(*cookies.signed[:logged_in]) if cookies.signed[:logged_in]
  end

  # From here on: Methods for the API registration process
  def api_credentials_changed?
    session['user_id'] != params['account']['user_id'] or session['api_key'] != params['account']['api_key']
  end

  def api_credentials_missing?
    params['account']['user_id'].blank? or params['account']['api_key'].blank?
  end
  
  def api_credentials_available?
    not api_credentials_missing?
  end

  def save_api_sessions
    session['user_id'] = params['account']['user_id']
    session['api_key'] = params['account']['api_key']
  end
  
  def clear_api_sessions
    session['user_id'] = session['api_key'] = nil
  end
  
  def user_nav
    @user_nav ||= Navigation.new NAV_MODULES
  end
  
end
