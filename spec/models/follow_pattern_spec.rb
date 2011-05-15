require 'spec_helper'

describe FollowPattern do
  before(:each) do
    @fp = FollowPattern.new(:instruction => "Instruction", :pattern => "m[y] ans[wer]")
  end
  describe "hint" do
    it "should substitute desired input with asterisk but do not substitute space" do
      @fp.hint.should == "*y ***wer"
    end
  end

  describe "answer" do
    it "should return pattern without the markup" do
      @fp.answer.should == "my answer"
    end
  end

  describe "score_for" do
    it "should return 1 for correct answer without regarding to case" do
      @fp.score_for("mY AnsweR").should == 1
    end

    it "should return 0 for incorrect answer" do
      @fp.score_for("mY Ans").should == 0
      @fp.score_for(nil).should == 0
    end
  end

  describe "preview" do
    it "should return instruction" do
      @fp.preview.should == "Instruction"
    end
  end
end
