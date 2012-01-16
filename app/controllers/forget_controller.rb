class ForgetController < ApplicationController
  
  def mail
    account = Account.find_by_email(params[:account][:email])
    if account
      # a character was found. Set password forget hash
      hash_chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      forgot_pw_hash = Array.new(20).map { hash_chars[rand(hash_chars.size-1)] }.join
      account.forgot_password_hash = forgot_pw_hash
      account.save!
      
      AccountMailer.send_async(:password_reset_mail, account)
      flash[:notice] = "An email with further instructions on how to reset your password has been sent to your email address"
      @redirect = {path: root_path, time: 0}
      render "redirect"
    else
      @message = {:alert => "There is no account registered with the e-mail adress you supplied"}
      render "error_page"
    end
  end
  
  def reset
    @account = Account.find_by_forgot_password_hash(params[:reset_hash])
    if @account
      render 'reset'
    else
      flash[:alert] = "Your password reset hash seems to be invalid. Please check your email for further instructions or request a new email."
      redirect_to forget_path
    end
  end
  
  def update
    @account = Account.find_by_forgot_password_hash(params[:reset_hash])
    @account.password = params[:account][:password]
    @account.password_confirmation = params[:account][:password_confirmation]
    @account.forgot_password_hash = nil
    if @account.save
      flash[:notice] = "Successfully set new password."
      @redirect = {path: login_path, time: 0}
      render "redirect"
    else
      render "inline_errors", :name => "forget.js"
    end
  end
end
