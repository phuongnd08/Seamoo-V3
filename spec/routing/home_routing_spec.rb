require "spec_helper"

describe HomeController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/" }.should route_to(:controller => "home", :action => "index")
      { :get => "/en" }.should route_to(:locale => 'en', :controller => "home", :action => "index")
      { :get => "/a" }.should_not be_routable
      { :get => "/random" }.should_not be_routable
    end
  end
end
