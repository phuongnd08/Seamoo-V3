require 'spec_helper'

describe Membership do
  describe "relationship" do
    it{should belong_to(:user)}
    it{should belong_to(:league)}
  end

  describe "instance" do
    before(:each){ @membership = Membership.new }

    describe "default value" do
      it { @membership.matches_count.should == 0 }
      it { @membership.matches_score.should == 0 }
      it { @membership.rank_score.should == 0 }
    end

    describe "add match score" do
      it "should update matches count and matches score" do
        @membership.add_match_score(4)
        @membership.matches_count.should == 1
        @membership.matches_score.should == 4
      end
    end

    describe "save" do
      it "should update rank_score according to matches_count & matches_score" do
        @membership.matches_count = 1
        @membership.matches_score = 4
        @membership.save
        @membership.rank_score.should == 4
      end

      it "should stand matches_count 0" do
        @membership.save
        @membership.rank_score.should == 0
      end
    end
  end
end
