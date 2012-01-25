class MailingListsController < ApplicationController
  # GET /mailing_lists
  # GET /mailing_lists.json
  def index
    MailingList.api_update_own(owner: current_user)

    @mailing_lists = current_user.mailing_lists.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mailing_lists }
    end
  end

  # GET /mailing_lists/1
  # GET /mailing_lists/1.json
  def show
    @mailing_list = MailingList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mailing_list }
    end
  end

  # GET /mailing_lists/new
  # GET /mailing_lists/new.json
  def new
    @mailing_list = MailingList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mailing_list }
    end
  end

  # GET /mailing_lists/1/edit
  def edit
    @mailing_list = MailingList.find(params[:id])
  end

  # POST /mailing_lists
  # POST /mailing_lists.json
  def create
    @mailing_list = MailingList.new(params[:mailing_list])

    respond_to do |format|
      if @mailing_list.save
        format.html { redirect_to @mailing_list, notice: 'Mailing list was successfully created.' }
        format.json { render json: @mailing_list, status: :created, location: @mailing_list }
      else
        format.html { render action: "new" }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mailing_lists/1
  # PUT /mailing_lists/1.json
  def update
    @mailing_list = MailingList.find(params[:id])

    respond_to do |format|
      if @mailing_list.update_attributes(params[:mailing_list])
        format.html { redirect_to @mailing_list, notice: 'Mailing list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailing_lists/1
  # DELETE /mailing_lists/1.json
  def destroy
    @mailing_list = MailingList.find(params[:id])
    @mailing_list.destroy

    respond_to do |format|
      format.html { redirect_to mailing_lists_url }
      format.json { head :no_content }
    end
  end
end
