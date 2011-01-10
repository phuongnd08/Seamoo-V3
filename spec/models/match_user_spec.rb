require 'spec_helper'

describe MatchUser do
  describe "relationships" do
    it {should belong_to(:user)}
    it {should belong_to(:match)}
  end
end
