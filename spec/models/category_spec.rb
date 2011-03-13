require 'spec_helper'

describe Category do
  describe "relationships" do
    it {should have_many(:leagues)}
    it {should have_many(:questions)}
  end

  describe "status" do
    it "should be active by default" do
      Category.new.status.should == "active"
    end

    it "can only be assigned to certain values" do
      Category.new(:status => "active").should be_valid
      Category.new(:status => "coming_soon").should be_valid
      Category.new(:status => "else").should_not be_valid
    end
  end
end
