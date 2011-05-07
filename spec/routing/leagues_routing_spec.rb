require "spec_helper"

describe LeaguesController do
  describe "routing" do
    it "recognizes and generates #show" do
      { :get => "/leagues/1" }.should route_to(:controller => "leagues", :action => "show", :id => "1")
      { :get => "/en/leagues/1" }.should route_to(:locale => 'en', :controller => "leagues", :action => "show", :id => "1")
    end
  end
end
