require "spec_helper"

describe SubjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/subjects").should route_to("subjects#index")
    end

    it "routes to #new" do
      get("/subjects/new").should route_to("subjects#new")
    end

    it "routes to #show" do
      get("/subjects/1").should route_to("subjects#show", :id => "1")
    end

    it "routes to #create" do
      post("/subjects").should route_to("subjects#create")
    end

    it "routes to #register" do
      post("/subjects/1/register").should route_to("subjects#register", :id => "1")
    end

    it "routes to #remove" do
      post("/subjects/1/remove").should route_to("subjects#remove", :id => "1")
    end
  end
end
