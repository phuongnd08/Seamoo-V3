require "spec_helper"

describe FollowPatternsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/follow_patterns/new" }.should route_to(:controller => "follow_patterns", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/follow_patterns/1" }.should route_to(:controller => "follow_patterns", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/follow_patterns/1/edit" }.should route_to(:controller => "follow_patterns", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/follow_patterns" }.should route_to(:controller => "follow_patterns", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/follow_patterns/1" }.should route_to(:controller => "follow_patterns", :action => "update", :id => "1")
    end

  end
end
