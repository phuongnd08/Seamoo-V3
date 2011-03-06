require "spec_helper"

describe MultipleChoicesController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/multiple_choices/new" }.should route_to(:controller => "multiple_choices", :action => "new")
      { :get => "/en/multiple_choices/new" }.should route_to(:locale => 'en', :controller => "multiple_choices", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/multiple_choices/1" }.should route_to(:controller => "multiple_choices", :action => "show", :id => "1")
      { :get => "/en/multiple_choices/1" }.should route_to(:locale => 'en', :controller => "multiple_choices", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/multiple_choices/1/edit" }.should route_to(:controller => "multiple_choices", :action => "edit", :id => "1")
      { :get => "/en/multiple_choices/1/edit" }.should route_to(:locale => 'en', :controller => "multiple_choices", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/multiple_choices" }.should route_to(:controller => "multiple_choices", :action => "create")
      { :post => "/en/multiple_choices" }.should route_to(:locale => 'en', :controller => "multiple_choices", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/multiple_choices/1" }.should route_to(:controller => "multiple_choices", :action => "update", :id => "1")
      { :put => "/en/multiple_choices/1" }.should route_to(:locale => 'en', :controller => "multiple_choices", :action => "update", :id => "1")
    end
  end
end
