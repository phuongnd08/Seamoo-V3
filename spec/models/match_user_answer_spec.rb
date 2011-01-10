require 'spec_helper'

describe MatchUserAnswer do
  describe "relationships" do
    it {should belong_to(:match_user)}
    it {should belong_to(:match_question)}
  end
end
