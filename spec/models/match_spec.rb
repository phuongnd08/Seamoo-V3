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
end
