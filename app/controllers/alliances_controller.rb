class AlliancesController < ApplicationController
  # GET /alliances
  # GET /alliances.json
  def index
    time = Time.now
    Alliance.api_update
    @alliances = Alliance.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alliances }
    end
    logger.warn "Total Alliance update Time: #{Time.now - time}"
  end

  # GET /alliances/1
  # GET /alliances/1.json
  def show
    @alliance = Alliance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alliance }
    end
  end

  # GET /alliances/new
  # GET /alliances/new.json
  def new
    @alliance = Alliance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alliance }
    end
  end

  # GET /alliances/1/edit
  def edit
    @alliance = Alliance.find(params[:id])
  end

  # POST /alliances
  # POST /alliances.json
  def create
    @alliance = Alliance.new(params[:alliance])

    respond_to do |format|
      if @alliance.save
        format.html { redirect_to @alliance, notice: 'Alliance was successfully created.' }
        format.json { render json: @alliance, status: :created, location: @alliance }
      else
        format.html { render action: "new" }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alliances/1
  # PUT /alliances/1.json
  def update
    @alliance = Alliance.find(params[:id])

    respond_to do |format|
      if @alliance.update_attributes(params[:alliance])
        format.html { redirect_to @alliance, notice: 'Alliance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alliances/1
  # DELETE /alliances/1.json
  def destroy
    @alliance = Alliance.find(params[:id])
    @alliance.destroy

    respond_to do |format|
      format.html { redirect_to alliances_url }
      format.json { head :no_content }
    end
  end
end
