class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :instantiate_controller_and_action_names
  helper_method :current_user, :current_account, :user_nav, :eve_time, :logged_in?

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
  # def current_account
  #   if cookies[:auth_token]
  #     @current_account ||= Account.find_by_auth_token(cookies[:auth_token])
  #   end
  # end

  # From here on: Methods for the API registration process
  def api_credentials_changed?
    session['api_id'] != params['account']['api_id'] or session['v_code'] != params['account']['v_code']
  end

  def api_credentials_missing?
    params['account']['api_id'].blank? or params['account']['v_code'].blank?
  end
  
  def api_credentials_available?
    not api_credentials_missing?
  end

  def save_api_sessions
    session['api_id'] = params['account']['api_id']
    session['v_code'] = params['account']['v_code']
  end
  
  def clear_api_sessions
    session['api_id'] = session['v_code'] = nil
  end
  
  def user_nav
    @user_nav ||= Navigation.new NAV_MODULES
  end 

  def logged_in?
    !! current_account
  end

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end

  def logout!(msg = true)
    cookies.delete :auth_token
    flash[:notice] = 'Your password or email have changed. Please login again' if msg
    redirect_to account_session_url
  end
end
