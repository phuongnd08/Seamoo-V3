require 'spec_helper'

describe Match do
  describe "relationships" do
    it {should have_many(:questions)}
    it {should have_many(:users)}
    it {should belong_to(:league)}
  end

  describe "timing" do
    before(:each) do
      Matching.stub(:finished_after).and_return(600)
      Matching.stub(:started_after).and_return(60)
    end

    describe "finished" do
      it "should return correct value with respect to Matching constants" do
        Match.new(:created_at => Time.now - 659.seconds).finished?.should == false
        Match.new(:created_at => Time.now - 660.seconds).finished?.should == true
      end
    end

    describe "started" do
      it "should return correct value" do
        Match.new(:created_at => Time.now - 59.seconds).started?.should == false
        Match.new(:created_at => Time.now - 60.seconds).started?.should == true
      end
    end
  end
end
