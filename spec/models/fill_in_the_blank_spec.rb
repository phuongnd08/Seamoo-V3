require 'spec_helper'

describe FillInTheBlank do
  before(:each) do
    @fib = FillInTheBlank.new(:content => "Once day I was {travel|travelling} on the {S[tr]eet} seeing {[a] girl} washing her stuff")
  end
  describe "answer" do
    it "should return the answers without the markup" do
      @fib.answer.should == "travelling, Street, a girl"
    end
  end
  describe "segments" do
    it "should return all the segments in format of type, and text or text" do
      @fib.segments.should == [{:type => "text", :text => "Once day I was "},
        {:type => "input", :hint => "travel", :no_highlight => true, :answer => "travelling"},
        {:type => "text", :text => " on the "},
        {:type => "input", :hint => "*tr***", :answer => "Street"},
        {:type => "text", :text => " seeing "},
        {:type => "input", :hint => "a ****", :answer => "a girl"},
        {:type => "text", :text => " washing her stuff"}]
    end
  end

  describe "preview" do
    it "should return all parts and trim down critial part" do
      @fib.preview.should == "Once day I was (travel) on the (*tr***) seeing (a ****) washing her stuff" 
    end
  end

  describe "score_for" do
    it "should return 1 for correct answer without regarding to case" do
      @fib.score_for("TraVelling, Street, a Girl").should == 1
    end

    it "should return less than 1 for answer with correct portion" do
      @fib.score_for("TraVelling, , A Girl").should be_within(0.001).of(2.0/3)
      @fib.score_for("TraVelling, wow, a Girl").should be_within(0.001).of(2.0/3)
      @fib.score_for("TraVelling, sTreet, ").should be_within(0.001).of(2.0/3)
      @fib.score_for(", sTreet, ").should be_within(0.001).of(1.0/3)
    end

    it "should return 0 for incorrect answer" do
      @fib.score_for(nil).should == 0
      @fib.score_for("Some bullshit answer").should == 0
    end
  end
end
