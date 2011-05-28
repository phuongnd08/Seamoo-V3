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
      Matching.bots.size.should == 2
      (Matching.bots[0].size + Matching.bots[1].size).should == 100
    end

    it "should contains proper key/value pairs" do
      Matching.bots[0]["than_dong_daiso"][:display_name].should == "Thần đồng đại số"
      Matching.bots[0]["ban_messi"][:display_name].should == "ban_messi"
      Matching.bots[1]["r10"][:display_name].should == "r10"
      Matching.bots[1]["vo_danh"][:display_name].should == "Vô Danh"
    end
  end
end
