class RegistrationController < ApplicationController
  include Wicked::Wizard

  steps :create_api, :create_character, :create_account

  def update
    case step
    when :create_api
      api_params = params[:api_key].merge({registration_token: SecureRandom.urlsafe_base64})
      @api_key = ApiKey.new(api_params)
      session[:registration_token] = api_params[:registration_token]
      render_wizard @api_key
    when :create_character
      @api_key = ApiKey.find_by_registration_token session[:registration_token]
      id_array = [params[:character][:main_character].to_i]
      @character = @api_key.create_characters_with_ids(id_array).first
      render_wizard @character
    when :create_account
      @api_key = ApiKey.find_by_registration_token session[:registration_token]
      @character = @api_key.characters.first
      @account = Account.new(params[:account])
      @account.main_character_id = @account.id
      # IF account can be succesfully saved, update character and api key
      if @account.save
        @character.account_id = @account.id
        @character.save
        @api_key.registration_token = nil
        @api_key.save
      else
        flash[:warning] = "Account could not be saved"
      end
      render_wizard @account
    else render_wizard
    end
  end

  def show
    case step
    when :create_api
      @api_key = ApiKey.new
    when :create_character
      @api_key = ApiKey.find_by_registration_token session[:registration_token]
    when :create_account
      @character = ApiKey.find_by_registration_token(session[:registration_token]).characters.first
      @account = Account.new
    end
    render_wizard
  end
end
