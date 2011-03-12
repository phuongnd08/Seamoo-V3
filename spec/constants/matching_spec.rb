require 'spec_helper'

describe Matching do
  it "should contain constant inform of accessor" do
    Matching.requester_stale_after.should_not be_nil
    Matching.started_after.should_not be_nil
    Matching.ended_after.should_not be_nil
    Matching.questions_per_match.should_not be_nil
    Matching.users_per_match.should_not be_nil
  end
end
