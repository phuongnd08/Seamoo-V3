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

  describe "GET active_players", :memcached => true do
    it "assign many fake active players as @active_players" do
      @league = Factory(:league)
      get :active_players, :id => @league.id
      assigns(:active_players).size.should >= 1
    end

    it "should always include the real active players" do
      @league = Factory(:league)
      user1 = Factory(:user)
      League.stub(:find).with(@league.id).and_return(@league)
      @league.stub(:active_users).and_return([{:id => user1.id}])
      get :active_players, :id => @league.id
      assigns(:active_players).values.should include(user1)
    end
  end
end
