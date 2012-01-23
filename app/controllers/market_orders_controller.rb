class MarketOrdersController < ApplicationController
  # GET /market_orders
  # GET /market_orders.json
  def index
    @market_orders = MarketOrder.all
    MarketOrder.api_update_own(owner: current_user)
  end

  # GET /market_orders/1
  # GET /market_orders/1.json
  def show
    @market_order = MarketOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @market_order }
    end
  end

  # GET /market_orders/new
  # GET /market_orders/new.json
  def new
    @market_order = MarketOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @market_order }
    end
  end

  # GET /market_orders/1/edit
  def edit
    @market_order = MarketOrder.find(params[:id])
  end

  # POST /market_orders
  # POST /market_orders.json
  def create
    @market_order = MarketOrder.new(params[:market_order])

    respond_to do |format|
      if @market_order.save
        format.html { redirect_to @market_order, notice: 'Market order was successfully created.' }
        format.json { render json: @market_order, status: :created, location: @market_order }
      else
        format.html { render action: "new" }
        format.json { render json: @market_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /market_orders/1
  # PUT /market_orders/1.json
  def update
    @market_order = MarketOrder.find(params[:id])

    respond_to do |format|
      if @market_order.update_attributes(params[:market_order])
        format.html { redirect_to @market_order, notice: 'Market order was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @market_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /market_orders/1
  # DELETE /market_orders/1.json
  def destroy
    @market_order = MarketOrder.find(params[:id])
    @market_order.destroy

    respond_to do |format|
      format.html { redirect_to market_orders_url }
      format.json { head :ok }
    end
  end
end
