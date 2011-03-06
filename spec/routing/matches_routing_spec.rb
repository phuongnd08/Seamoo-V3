require "spec_helper"

describe MatchesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/matches" }.should route_to(:controller => "matches", :action => "index")
      { :get => "/en/matches" }.should route_to(:locale => 'en', :controller => "matches", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/matches/1" }.should route_to(:controller => "matches", :action => "show", :id => "1")
      { :get => "/en/matches/1" }.should route_to(:locale => 'en', :controller => "matches", :action => "show", :id => "1")
    end
  end
end
