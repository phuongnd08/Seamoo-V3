require 'spec_helper'

describe MatchesController do
  before(:each) do
    @match = Factory(:match)
    @match.fetch_questions!
    @user = Factory(:user)
    @match.users << @user
  end

  describe "GET index" do
    it "assigns all matches as @matches" do
      get :index
      assigns(:matches).should == [@match]
    end
  end

  describe "GET show" do
    context "match not finished" do
      it "should block access with notice" do
        get :show, :id => @match.id
        response.should redirect_to(league_path(@match.league))
        flash[:error].should == "Match is not finished, details are not available."
      end
    end

    context "match finished" do
      before(:each) do
        @match.update_attribute(:finished_at, Time.now)
      end

      it "should require use_formulae if the league do so" do
        @match.league.update_attribute(:use_formulae, true);
        get :show, :id => @match.id
        assigns(:use_formulae).should be_true
      end

      it "assigns the requested match as @match" do
        get :show, :id => @match.id
        assigns(:match).should == @match
      end

      context "for players of the match" do
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

      context "for players not participating in match" do
        it "should hide all answers" do
          get :show, :id => @match.id
          assigns[:hide_all_answers].should be_true
        end
      end
    end
  end

  describe 'POST submit_answer' do
    before(:each) do
      @match.fetch_questions!
      controller.stub(:current_user).and_return(@user)
    end

    it "should save user question" do
      Services::PubSub.stub(:publish)
      post :submit_answer, :id => @match.id, :position => 1, :answer => "2"
      @match.match_user_for(@user).answers[1].should == "2"
      JSON.parse(response.body)["successful"].should be_true
    end
  end
end
