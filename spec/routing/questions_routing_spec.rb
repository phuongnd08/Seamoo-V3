require "spec_helper"

describe QuestionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/questions" }.should route_to(:controller => "questions", :action => "index")
      { :get => "/en/questions" }.should route_to(:locale => 'en', :controller => "questions", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/questions/1" }.should route_to(:controller => "questions", :action => "show", :id => "1")
      { :get => "/en/questions/1" }.should route_to(:locale => 'en', :controller => "questions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/questions/1/edit" }.should route_to(:controller => "questions", :action => "edit", :id => "1")
      { :get => "/en/questions/1/edit" }.should route_to(:locale => 'en', :controller => "questions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/questions/1" }.should route_to(:controller => "questions", :action => "destroy", :id => "1")
      { :delete => "/en/questions/1" }.should route_to(:locale => 'en', :controller => "questions", :action => "destroy", :id => "1")
    end

  end
end
