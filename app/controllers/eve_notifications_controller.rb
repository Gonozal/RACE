class EveNotificationsController < ApplicationController
  # GET /eve_notifications
  # GET /eve_notifications.json
  def index
    EveNotification.api_update(owner: current_user)
    @eve_notifications = EveNotification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @eve_notifications }
    end
  end

  # GET /eve_notifications/1
  # GET /eve_notifications/1.json
  def show
    @eve_notification = EveNotification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eve_notification }
    end
  end

  # GET /eve_notifications/new
  # GET /eve_notifications/new.json
  def new
    @eve_notification = EveNotification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eve_notification }
    end
  end

  # GET /eve_notifications/1/edit
  def edit
    @eve_notification = EveNotification.find(params[:id])
  end

  # POST /eve_notifications
  # POST /eve_notifications.json
  def create
    @eve_notification = EveNotification.new(params[:eve_notification])

    respond_to do |format|
      if @eve_notification.save
        format.html { redirect_to @eve_notification, notice: 'Eve notification was successfully created.' }
        format.json { render json: @eve_notification, status: :created, location: @eve_notification }
      else
        format.html { render action: "new" }
        format.json { render json: @eve_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /eve_notifications/1
  # PUT /eve_notifications/1.json
  def update
    @eve_notification = EveNotification.find(params[:id])

    respond_to do |format|
      if @eve_notification.update_attributes(params[:eve_notification])
        format.html { redirect_to @eve_notification, notice: 'Eve notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eve_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eve_notifications/1
  # DELETE /eve_notifications/1.json
  def destroy
    @eve_notification = EveNotification.find(params[:id])
    @eve_notification.destroy

    respond_to do |format|
      format.html { redirect_to eve_notifications_url }
      format.json { head :no_content }
    end
  end
end
