require 'spec_helper'

describe LeaguesController do

  def mock_league(stubs={})
    @mock_league ||= mock_model(League, stubs).as_null_object
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

  describe "GET matching" do
    render_views
    before(:each) do
      controller.stub(:current_user).and_return(Factory(:user))
    end

    it "should not provide mathjax only if not required" do
      @league = Factory(:league)
      get :matching, :id => @league.id 
      response.body.should_not include("MathJax.js")
    end

    it "should provide mathjax if required" do
      @league = Factory(:league, :use_formulae => true)
      get :matching, :id => @league.id 
      response.body.should include("MathJax.js")
    end
  end
end
