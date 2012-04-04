require "spec_helper"

describe FittingsController do
  describe "routing" do

    it "routes to #index" do
      get("/fittings").should route_to("fittings#index")
    end

    it "routes to #new" do
      get("/fittings/new").should route_to("fittings#new")
    end

    it "routes to #show" do
      get("/fittings/1").should route_to("fittings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fittings/1/edit").should route_to("fittings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fittings").should route_to("fittings#create")
    end

    it "routes to #update" do
      put("/fittings/1").should route_to("fittings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fittings/1").should route_to("fittings#destroy", :id => "1")
    end

  end
end
