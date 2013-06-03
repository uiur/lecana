require "spec_helper"

describe UsersController do
  describe "routing" do
    it "routes to #show" do
      get("/users/hoge").should route_to("users#show", :name => 'hoge')
    end

    it 'routes to #timetable' do
      get('/users/hoge/timetable').should route_to('users#timetable', :name => 'hoge')
    end
  end
end
