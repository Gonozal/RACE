class EveAssetsController < ApplicationController
  # GET /eve_assets
  # GET /eve_assets.json
  def index
    time = Time.now
    EveAsset.api_update_own(owner: current_user)
    @eve_assets = current_user.eve_assets.scoped.arrange
    time2 = Time.now
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @eve_assets }
      logger.warn "Total API update & query time: #{time2 - time}"
    end
  end

  # GET /eve_assets/1
  # GET /eve_assets/1.json
  def show
    @eve_asset = EveAsset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eve_asset }
    end
  end

  # GET /eve_assets/new
  # GET /eve_assets/new.json
  def new
    @eve_asset = EveAsset.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eve_asset }
    end
  end

  # GET /eve_assets/1/edit
  def edit
    @eve_asset = EveAsset.find(params[:id])
  end

  # POST /eve_assets
  # POST /eve_assets.json
  def create
    @eve_asset = EveAsset.new(params[:eve_asset])

    respond_to do |format|
      if @eve_asset.save
        format.html { redirect_to @eve_asset, notice: 'Eve asset was successfully created.' }
        format.json { render json: @eve_asset, status: :created, location: @eve_asset }
      else
        format.html { render action: "new" }
        format.json { render json: @eve_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /eve_assets/1
  # PUT /eve_assets/1.json
  def update
    @eve_asset = EveAsset.find(params[:id])

    respond_to do |format|
      if @eve_asset.update_attributes(params[:eve_asset])
        format.html { redirect_to @eve_asset, notice: 'Eve asset was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @eve_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eve_assets/1
  # DELETE /eve_assets/1.json
  def destroy
    @eve_asset = EveAsset.find(params[:id])
    @eve_asset.destroy

    respond_to do |format|
      format.html { redirect_to eve_assets_url }
      format.json { head :ok }
    end
  end
end
