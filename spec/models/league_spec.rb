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
end
