# encoding: utf-8
require 'spec_helper'

describe Matching do
  it "should contain constant inform of accessor" do
    Matching.requester_stale_after.should_not be_nil
    Matching.started_after.should_not be_nil
    Matching.ended_after.should_not be_nil
    Matching.questions_per_match.should_not be_nil
    Matching.users_per_match.should_not be_nil
  end

  describe "bots" do
    it "should have correct size" do
      Matching.bots.size.should == 100
    end

    it "should contains proper key/value pairs" do
      Matching.bots["than_dong_daiso"].should == "Thần đồng đại số"
      Matching.bots["ban_messi"].should == "ban_messi"
    end
  end
end
