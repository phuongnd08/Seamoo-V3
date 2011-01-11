require 'spec_helper'

describe MatchRequest do
  describe "relationships" do
    it {should belong_to(:league)}
    it {should belong_to(:user)}
    it {should belong_to(:match)}
  end
end
