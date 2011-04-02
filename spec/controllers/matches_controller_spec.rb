require 'spec_helper'

describe MatchesController do

  def mock_match(stubs={})
    (@mock_match ||= mock_model(Match).as_null_object).tap do |match|
      match.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all matches as @matches" do
      Match.stub(:all) { [mock_match] }
      get :index
      assigns(:matches).should eq([mock_match])
    end
  end

  describe "GET show" do
    before(:each) do
      @match = Factory(:match)
      @user = Factory(:user)
      @match.users << @user
    end

    it "assigns the requested match as @match" do
      get :show, :id => @match.id
      assigns(:match).should == @match
    end

    describe "for players of the match" do
      before(:each) do
        controller.stub(:current_user).and_return(@user)
      end

      it "should not hide all answers" do
        get :show, :id => @match.id
        assigns[:hide_all_answers].should be_false
      end

      describe "user league membership doesnot exist" do
        it "should create membership" do
          get :show, :id => @match.id
          mbs = Membership.find_by_league_id_and_user_id(@match.league.id, @user.id)
          mbs.should_not be_nil
          mbs.matches_count.should == 1
          mbs.matches_score.should == 0
        end
      end

      describe "user league membership already exists" do
        before(:each) do
          Membership.create(:league => @match.league, :user => @user).add_match_score(1)
        end
        it "should add that match score into player membership" do
          get :show, :id => @match.id
          mbs = Membership.find_by_league_id_and_user_id(@match.league.id, @user.id)
          mbs.matches_count.should == 2
          mbs.matches_score.should == 1
        end
      end
    end

    describe "for players not participating in match" do
      it "should hide all answers" do
        get :show, :id => @match.id
        assigns[:hide_all_answers].should be_true
      end
    end
  end
end
