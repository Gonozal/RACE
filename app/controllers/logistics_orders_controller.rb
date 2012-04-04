class LogisticsOrdersController < ApplicationController
  # GET /logistics_orders
  # GET /logistics_orders.json
  def index
    @logistics_orders = LogisticsOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logistics_orders }
    end
  end

  # GET /logistics_orders/1
  # GET /logistics_orders/1.json
  def show
    @logistics_order = LogisticsOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @logistics_order }
    end
  end

  # GET /logistics_orders/new
  # GET /logistics_orders/new.json
  def new
    @logistics_order = LogisticsOrder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @logistics_order }
    end
  end

  # GET /logistics_orders/1/edit
  def edit
    @logistics_order = LogisticsOrder.find(params[:id])
  end

  # POST /logistics_orders
  # POST /logistics_orders.json
  def create
    @logistics_order = LogisticsOrder.new(params[:industry_job])

    respond_to do |format|
      if @logistics_order.save
        format.html { redirect_to @logistics_order, notice: 'Order was successfully created.' }
        format.json { render json: @logistics_order, status: :created, location: @logistics_order }
      else
        format.html { render action: "new" }
        format.json { render json: @logistics_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /logistics_orders/1
  # PUT /logistics_orders/1.json
  def update
    @logistics_order = LogisticsOrder.find(params[:id])

    respond_to do |format|
      if @logistics_order.update_attributes(params[:logistics_order])
        format.html { redirect_to @logistics_order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @logistics_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logistics_orders/1
  # DELETE /logistics_orders/1.json
  def destroy
    @logistics_order = LogisticsOrder.find(params[:id])
    @logistics_order.destroy

    respond_to do |format|
      format.html { redirect_to logistics_orders_url }
      format.json { head :no_content }
    end
  end

  # POST /logistics_orders/:order_id/add_item.json
  def add_item
    @new_item = LogisticsOrder.find(params[:order_id]).add_item(params[:id])
    if @new_item.save
      respond_to do |format|
        format.js
      end
    else
      render json: @new_item.errors, status: :unprocessable_entity
    end
  end
end
