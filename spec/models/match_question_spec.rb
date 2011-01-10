require 'spec_helper'

describe MatchQuestion do
  describe "relationships" do
    it {should belong_to(:match)}
    it {should belong_to(:question)}
  end
end
