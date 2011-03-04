require 'spec_helper'

describe Match do
  describe "relationships" do
    it {should have_many(:questions)}
    it {should have_many(:users)}
    it {should belong_to(:league)}
  end

  describe "timing" do
    before(:each) do
      Matching.stub(:ended_after).and_return(600)
      Matching.stub(:started_after).and_return(60)
    end

    describe "started" do
      it "should return correct value" do
        Match.new(:created_at => Time.now - 59.seconds).started?.should == false
        Match.new(:created_at => Time.now - 60.seconds).started?.should == true
      end
    end

    describe "seconds_until_start" do
      it "should return number of seconds until match started" do
        Match.new(:created_at => Time.now - 20.seconds).seconds_until_started.should == 40
        Match.new(:created_at => Time.now - 60.seconds).seconds_until_started.should == 0
      end

      it "should not return negative value if the match is started already" do
        Match.new(:created_at => Time.now - 70.seconds).seconds_until_started.should == 0
      end
    end

    describe "ended" do
      it "should return correct value with respect to Matching constants" do
        Match.new(:created_at => Time.now - 659.seconds).ended?.should == false
        Match.new(:created_at => Time.now - 660.seconds).ended?.should == true
      end
    end

    describe "finished" do
      it "should return true if either the match is ended or finished_at is set" do
        Match.new(:created_at => Time.now - 659.seconds).finished?.should == false
        Match.new(:created_at => Time.now - 660.seconds).finished?.should == true 
        Match.new(:created_at => Time.now - 650.seconds, :finished_at => 1.second.ago).finished?.should == true 
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
