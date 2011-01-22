require 'spec_helper'

describe Match do
  describe "relationships" do
    it {should have_many(:questions)}
    it {should have_many(:users)}
    it {should belong_to(:league)}
  end

  describe "finished" do
    it "should return correct value" do
      Match.new(:created_at => Time.now - 10.seconds).finished?.should == false
      Match.new(:created_at => Time.now - 20.seconds).finished?.should == false
      Match.new(:created_at => Time.now - 80.seconds).finished?.should == true
    end
  end

  describe "started" do
    it "should return correct value" do
      Match.new(:created_at => Time.now - 10.seconds).started?.should == false
      Match.new(:created_at => Time.now - 20.seconds).started?.should == true
      Match.new(:created_at => Time.now - 80.seconds).started?.should == true
    end
  end
end
