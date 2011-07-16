require 'spec_helper'

describe Match do
  before(:all) do
    MatchingSettings.started_after #trigger MatchingSettings initialization so that stub can work properly
  end
  describe "relationships" do
    it {should have_many(:questions)}
    it {should have_many(:users)}
    it {should belong_to(:league)}
  end

  describe "coordinate requests", :caching => true do
    before(:each) do
      MatchingSettings.stub(:duration).and_return(600)
      MatchingSettings.stub(:started_after).and_return(60)
      @users = (0..5).map { Factory(:user) }
      @league = Factory(:league_with_questions)
      @match = Match.create(:league => @league)
    end

    describe "subscribe" do
      context "match not started" do
        it "should accept all users" do
          now = Time.now
          Time.stub(:now).and_return(now)
          5.times do |index|
            @match.subscribe(@users[index]).should be_true
          end
        end

        it "should create match users" do
          now = Time.now
          Time.stub(:now).and_return(now)
          5.times do |index|
            @match.subscribe(@users[index])
            @match.match_user_for(@users[index]).should_not be_nil
          end
        end

        context "minimum number of users not reached" do
          before(:each) do
            @now = Time.now
            Time.stub(:now).and_return(@now)
            MatchingSettings.stub(:min_users_per_match).and_return(3)
            2.times do |index|
              @match.subscribe(@users[index])
            end
          end

          it "should not mark itself as formed" do
            @match.formed?.should be_false
            @match.formed_at.should be_nil
          end

          it "should not fetch questions" do
            @match.questions.should be_empty
          end
        end

        context "minimum number of users reached" do
          before(:each) do
            @now = Time.now
            Time.stub(:now).and_return(@now)
            MatchingSettings.stub(:min_users_per_match).and_return(3)
            3.times do |index|
              @match.subscribe(@users[index])
            end
          end

          it "should mark itself as formed" do
            @match.formed?.should be_true
            @match.formed_at.should == @now
          end

          it "should fetch questions" do
            @match.questions.should_not be_empty
          end
        end
      end

      context "match started" do
        before(:each) do
          @now = Time.now
          Time.stub(:now).and_return(@now)
          MatchingSettings.stub(:min_users_per_match).and_return(3)
          3.times do |index|
            @match.subscribe(@users[index])
          end
          Time.stub(:now).and_return(@now + (MatchingSettings.started_after + 1).seconds)
        end

        it "should accept already-a-player user" do
          (0..2).each do |index|
            @match.subscribe(@users[index]).should be_true
          end
        end

        it "should reject new user" do
          (3..5).each do |index|
            @match.subscribe(@users[index]).should be_false
          end
        end
      end
    end

    describe "started" do
      it "should return correct value" do
        Match.new(:formed_at => Time.now - 59.seconds).started?.should == false
        Match.new(:formed_at => Time.now - 60.seconds).started?.should == true
      end
    end

    describe "seconds_until_start" do
      it "should return number of seconds until match started" do
        Match.new(:formed_at => Time.now - 20.seconds).seconds_until_start.should == 40
        Match.new(:formed_at => Time.now - 60.seconds).seconds_until_start.should == 0
      end

      it "should not return negative value if the match is started already" do
        Match.new(:formed_at => Time.now - 70.seconds).seconds_until_start.should == 0
      end
    end

    describe "ended" do
      it "should return correct value with respect to Matching constants" do
        Match.new(:formed_at => Time.now - 659.seconds).ended?.should == false
        Match.new(:formed_at => Time.now - 660.seconds).ended?.should == true
      end
    end

    describe "finished" do
      it "should return true if either the match is ended or finished_at is set" do
        Match.new(:formed_at => Time.now - 659.seconds).finished?.should == false
        Match.new(:formed_at => Time.now - 660.seconds).finished?.should == true
        Match.new(:formed_at => Time.now - 650.seconds, :finished_at => 1.second.ago).finished?.should == true
      end
    end
  end

  describe "check_if_finished!" do
    it "should update finished_at according to whether all match users finished" do
      time1 = Time.mktime(2000, 1, 12)
      time2 = Time.mktime(2000, 1, 13)
      match = Match.new
      match.stub(:save!)
      match_user1 = MatchUser.create
      match_user2 = MatchUser.create
      match.match_users = [match_user1, match_user2]
      match_user1.finished_at = time1
      match.check_if_finished!
      match.finished_at.should be_nil
      match_user2.finished_at = time2
      match.check_if_finished!
      match.finished_at.should == time2
    end

    it "should re-save the match object" do
      match = Match.new
      match.should_receive(:save!)
      match.check_if_finished!
    end
  end

  describe "ranked_match_users" do
    it "should return array of user sorted by score descending" do
      match = Match.new
      match_user1 = mock_model(MatchUser)
      match_user2 = mock_model(MatchUser)
      match_user3 = mock_model(MatchUser)
      match_user1.stub(:score).and_return(5)
      match_user2.stub(:score).and_return(10)
      match_user3.stub(:score).and_return(7)
      match.match_users = [match_user1, match_user2, match_user3]
      match.ranked_match_users.should == [match_user2, match_user3, match_user1]
    end
  end
end
