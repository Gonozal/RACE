class SessionsController < ApplicationController
  def new
    if current_account
      redirect_to root_url
    end
  end

  # Create new session if login credentials are valid (login)
  def create
    account = Account.authenticate(params[:name], params[:password])
    if account || current_account
      if params[:remember_me]
        cookies.permanent.signed[:logged_in] = [account.id, account.password.salt]
      else
        cookies.signed[:logged_in] = [account.id, account.password.salt]
      end
      flash[:success] = "You have successfully been logged in."
      redirect_to root_url
    else
      flash.now.alert = "invalid account name or password."
      render "new"
    end
  end

  # Destroy session if /logout has been called (logout)
  def destroy
    cookies[:logged_in] = nil
    redirect_to root_url
  end
end
