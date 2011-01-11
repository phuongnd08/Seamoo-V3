require 'spec_helper'

describe League do
  describe "relationships" do
    it { should belong_to(:category)}
  end

  describe "request_match" do
    before(:each) do
      @user = Factory.create(:user)
      @league = League.create!
    end
    describe "user does not have opening match" do
      describe "user does not have any opening request" do
        it "should create new match request" do
          lambda{@league.request_match(:user => @user)}.should change(MatchRequest, :count).by(1)
          last = MatchRequest.last
          last.league.should == @league
          last.user.should == @user
          last.match.should == nil
        end
      end

      describe "user does have opening request" do
        describe "user does not have match" do
          before(:each) do
            skip_timestamps(MatchRequest){
              MatchRequest.create(:league => @league, :user => @user, :updated_at => Time.now - 1.second)
            }
          end
          it "should update existing match request" do
            last = MatchRequest.last
            updated_at = last.updated_at
            lambda{@league.request_match(:user => @user)}.should change(MatchRequest, :count).by(0)
            last = last.reload
            last.league.should == @league
            last.user.should == @user
            last.match.should == nil
            last.updated_at.should > updated_at
          end
        end

        describe "user have opening match" do
          before(:each) do
            match = Match.create
            skip_timestamps(MatchRequest){
              MatchRequest.create(:league => @league, :user => @user, :updated_at => Time.now - 1.second, :match => match)
            }
          end

          it "should ignore match request" do
            last = MatchRequest.last
            updated_at = last.updated_at
            lambda{@league.request_match(:user => @user)}.should change(MatchRequest, :count).by(0)
            last.reload.updated_at.should == updated_at
          end
        end

        describe "user have closed match" do
          before(:each) do
            match = skip_timestamps(Match){Match.create(:created_at => Time.now - 1.hour)}
            Match.record_timestamps = true
            skip_timestamps(MatchRequest){
              MatchRequest.create(:league => @league, :user => @user, :updated_at => Time.now - 1.second, :match => match)
            }
          end

          it "should refresh match request" do
            last = MatchRequest.last
            updated_at = last.updated_at
            lambda{@league.request_match(:user => @user)}.should change(MatchRequest, :count).by(0)
            last.reload.updated_at.should > updated_at
            last.match.should == nil
          end
        end
      end
    end
  end
end
