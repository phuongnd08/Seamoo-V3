require 'spec_helper'

describe MatchSubscription do
  describe "relationships" do
    it {should belong_to(:league)}
    it {should belong_to(:user)}
  end

  describe "change updated_at time" do
    it "should force updated_at time to now" do
      match_subscription = MatchSubscription.create
      updated_at = match_subscription.updated_at
      sleep 1
      match_subscription.touch
      match_subscription.updated_at.should > updated_at
    end
  end
end
