class EveMailsController < ApplicationController
  # GET /eve_mails
  # GET /eve_mails.json
  def index
    @eve_mails = EveMail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @eve_mails }
    end
  end

  # GET /eve_mails/1
  # GET /eve_mails/1.json
  def show
    @eve_mail = EveMail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eve_mail }
    end
  end

  # GET /eve_mails/new
  # GET /eve_mails/new.json
  def new
    @eve_mail = EveMail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eve_mail }
    end
  end

  # GET /eve_mails/1/edit
  def edit
    @eve_mail = EveMail.find(params[:id])
  end

  # POST /eve_mails
  # POST /eve_mails.json
  def create
    @eve_mail = EveMail.new(params[:eve_mail])

    respond_to do |format|
      if @eve_mail.save
        format.html { redirect_to @eve_mail, notice: 'Eve mail was successfully created.' }
        format.json { render json: @eve_mail, status: :created, location: @eve_mail }
      else
        format.html { render action: "new" }
        format.json { render json: @eve_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /eve_mails/1
  # PUT /eve_mails/1.json
  def update
    @eve_mail = EveMail.find(params[:id])

    respond_to do |format|
      if @eve_mail.update_attributes(params[:eve_mail])
        format.html { redirect_to @eve_mail, notice: 'Eve mail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eve_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eve_mails/1
  # DELETE /eve_mails/1.json
  def destroy
    @eve_mail = EveMail.find(params[:id])
    @eve_mail.destroy

    respond_to do |format|
      format.html { redirect_to eve_mails_url }
      format.json { head :no_content }
    end
  end
end
