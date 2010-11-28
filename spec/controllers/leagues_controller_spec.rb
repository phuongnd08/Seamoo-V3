require 'spec_helper'

describe LeaguesController do

  def mock_league(stubs={})
    @mock_league ||= mock_model(League, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all leagues as @leagues" do
      League.stub(:all) { [mock_league] }
      get :index
      assigns(:leagues).should eq([mock_league])
    end
  end

  describe "GET show" do
    it "assigns the requested league as @league" do
      League.stub(:find).with("37") { mock_league }
      get :show, :id => "37"
      assigns(:league).should be(mock_league)
    end
  end
end
