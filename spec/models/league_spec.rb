require 'spec_helper'

describe League do
  describe "relationships" do
    it { should belong_to(:category)}
    it { should have_many(:matches)}
  end

  describe "dynamic accessor" do
    before(:each) do
      @user = Factory.create(:user)
      @league = League.create!
      Class.new.extend(Utils::Memcached::Common).client.flush_all # clear memecached
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

  describe "request_match" do
    before(:each) do
      @user1 = Factory.create(:user)
      @user2 = Factory.create(:user)
      @league = League.create!
      Class.new.extend(Utils::Memcached::Common).client.flush_all # clear memecached
    end

    it "should never mess up" do
      initial_time = Time.mktime(2000, 12, 31)
      Time.stub(:now).and_return(initial_time)
      match_1t = @league.request_match(@user1.id)
      match_1a = @league.request_match(@user2.id)
      match_1b = @league.request_match(@user1.id)
      match_1t.should be_nil
      match_1a.should_not be_nil
      match_1b.should == match_1a

      (Matching.started_after + Matching.ended_after).times.each do |t|

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
  end
end
