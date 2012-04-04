class FittingsController < ApplicationController
  # GET /fittings
  # GET /fittings.json
  def index
    @fittings = Fitting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fittings }
    end
  end

  # GET /fittings/1
  # GET /fittings/1.json
  def show
    @fitting = Fitting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fitting }
    end
  end

  # GET /fittings/new
  # GET /fittings/new.json
  def new
    @fitting = Fitting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fitting }
    end
  end

  # GET /fittings/1/edit
  def edit
    @fitting = Fitting.find(params[:id])
  end

  # POST /fittings
  # POST /fittings.json
  def create
    @fitting = Fitting.new(params[:fitting])

    respond_to do |format|
      if @fitting.save
        format.html { redirect_to @fitting, notice: 'Fitting was successfully created.' }
        format.json { render json: @fitting, status: :created, location: @fitting }
      else
        format.html { render action: "new" }
        format.json { render json: @fitting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fittings/1
  # PUT /fittings/1.json
  def update
    @fitting = Fitting.find(params[:id])

    respond_to do |format|
      if @fitting.update_attributes(params[:fitting])
        format.html { redirect_to @fitting, notice: 'Fitting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fitting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fittings/1
  # DELETE /fittings/1.json
  def destroy
    @fitting = Fitting.find(params[:id])
    @fitting.destroy

    respond_to do |format|
      format.html { redirect_to fittings_url }
      format.json { head :no_content }
    end
  end
end
