class CorporationsController < ApplicationController
  def index
    @corporations = Corporation.all
  end
  
  def show
    @corporation = Corporation.find(params[:id])
  end
  
  def new
    @corporation = Corporation.new
  end
  
  def create
    @corporation = Corporation.new
  end
  
  def destroy
    @corporation = Corporation.find(params[:id])
    @corporation.delete
  end
  
end
