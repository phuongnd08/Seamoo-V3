require 'spec_helper'

describe Matching do
  it "should contain constant inform of accessor" do
    Matching.should respond_to(:requester_stale_after)
    Matching.should respond_to(:started_after)
    Matching.should respond_to(:ended_after)
  end
end
