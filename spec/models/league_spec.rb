require 'spec_helper'

describe League do
  describe "relationships" do
    it { should belong_to(:category)}
    it { should have_many(:matches)}
  end

  describe "dynamic accessor" do
    before(:each) do
      @league = League.create!(:level => 0)
    end

    it "should be maintained correctly" do
      now = Time.now.to_i
      @league.send(:user_ticket)[1] = "abc_#{now}"        
      @league.send(:user_lastseen)[1] = "lastseen_#{now}"        
      @league.send(:user_ticket)[1].should == "abc_#{now}"        
      @league.send(:user_lastseen)[1].should == "lastseen_#{now}"        
      @league.send(:user_ticket_counter).incr.should == 1
      @league.send(:user_ticket_counter).incr.should == 2
      @league.send(:user_ticket_counter).incr.should == 3
    end
  end

  describe "coordinate requests in league" do
    before(:each) do
      @category = Factory(:category)
      @user1 = Factory(:user)
      @user2 = Factory(:user)
      @questions = []
      (1..3).each do |t|
        @questions << Factory(:question, :level => 0, :category => @category)
      end
      @league = League.create!(:level => 0, :category => @category)
    end

    describe "request_match" do
      it "should never mess up" do
        initial_time = Time.now
        Time.stub(:now).and_return(initial_time)
        match_1t = @league.request_match(@user1.id)
        match_1a = @league.request_match(@user2.id)
        match_1b = @league.request_match(@user1.id)
        match_1t.should be_nil
        match_1a.should_not be_nil
        match_1b.should == match_1a

        Matching.started_after.step(Matching.ended_after, Matching.requester_stale_after - 1) do |t|
          Time.stub(:now).and_return(initial_time + t.seconds) 
          @league.request_match(@user1.id)
          @league.request_match(@user2.id)
        end
        Time.stub(:now).and_return(initial_time + (Matching.started_after + Matching.ended_after + 1).seconds) 
        match_2t = @league.request_match(@user1.id)
        match_2a = @league.request_match(@user2.id)
        match_2b = @league.request_match(@user1.id)

        match_2t.should be_nil
        match_2a.should_not be_nil
        match_2b.should == match_2a

        match_2a.id.should == match_1a.id+1
      end

      it "should assign questions to match" do
        Matching.stub(:questions_per_match).and_return(3)
        @league.request_match(@user1.id)
        match = @league.request_match(@user2.id)
        match.questions.map(&:id).to_set.should == @questions.map(&:id).to_set
      end
    end

    describe "waiting_user_ids" do
      it "should return number users are waiting for match" do
        @league.request_match(@user1.id)
        @league.waiting_user_ids.count.should  == 1
        @league.request_match(@user1.id)
        @league.waiting_user_ids.count.should == 1
        @league.request_match(@user2.id)
        @league.waiting_user_ids.count.should == 2
      end

      it "should take into account the time" do
        now = Time.now
        Time.stub(:now).and_return(now - Matching.requester_stale_after.seconds)
        @league.request_match(@user1.id)
        Time.stub(:now).and_return(now)
        @league.waiting_user_ids.count.should  == 0
        @league.request_match(@user1.id)
        @league.waiting_user_ids.count.should  == 1
      end
    end
  end
end
