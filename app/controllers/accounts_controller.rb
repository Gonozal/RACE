class AccountsController < ApplicationController
  
  
  def index
    @accounts = Account.all
  end

  def show
    @account = current_account
  end

  def new
    if current_account.blank?
      @account = Account.new
    else 
      redirect_to login_url
    end
  end

  def edit
    @account = current_account
    render "edit" 
  end

  def update
    @account = current_account
    if @account.password == params[:account][:old_password] 
      if @account.update_attributes(:password => params[:account][:password], :password_confirmation => params[:account][:password_confirmation])
        cookies.permanent.signed[:logged_in] = [@account.id, @account.password.salt]
        @success_type = "update_account"
        render "success"
      else 
        render "inline_errors"
      end
    else
      @account.errors.add :old_password, "The Password you entered is incorrect"
      render "inline_errors"
    end
  end
  
  def create
    @account = Account.new(params['account'])
    if @account.save
      account = Account.find_by_name(@account.name)
      cookies.permanent.signed[:logged_in] = [account.id, account.password.salt]
      @success_type = "create_account"
      render "success"
    else
      render "inline_errors"
    end
  end
  
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
  end
  
  
  # changes the main_character to a new main character.
  def change_main_character
    # new main_character has to be a registered character of the account, so filter all possible
    # characters by character_id to get a valid new main_character
    new_main =  current_account.characters.to_a.find{ |c| c.character_id == params['id'].to_i }
    # If a character could be found, register it as new main_character.
    if new_main
      current_account.main_character = new_main
      current_account.save!
    end
    # redirect back to the site the user was before
    redirect_to :back
  end
  
end