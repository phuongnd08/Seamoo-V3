require 'spec_helper'

describe Nest, :caching => true do
  before(:each) do
    @n = Nest.new(:nest)
  end
  it "should get and set value properly" do
    @n[:foo].set "wow"
    @n[:foo][:bar].set "yeah"
    @n[:foo][:bar].get.should == "yeah"
    @n[:foo].get.should == "wow"
  end

  it "should be extended with more getter" do
    @n[:foo].set 1
    @n[:foo].get_i.should == 1
    @n[:foo].set false
    @n[:foo].get_b.should == false
    @n[:foo].set true
    @n[:foo].get_b.should == true
  end

  it "should handle nil  graciously" do
    @n[:foo].set nil
    @n[:foo].get.should == nil
  end

  it "should incr value properly" do
    @n[:foo].incr.should == 1
    @n[:foo].incr.should == 2
  end

  it "should add, remove and check for member of set properly" do
    @n[:foo].sadd "a"
    @n[:foo].sadd "b"
    @n[:foo].sismember("a").should be_true
    @n[:foo].sismember("b").should be_true
    @n[:foo].srem "a"
    @n[:foo].sismember("a").should be_false
    @n[:foo].sismember("b").should be_true
  end
end
