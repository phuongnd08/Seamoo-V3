require 'spec_helper'

describe FillInTheBlank do
  before(:each) do
    @fib = FillInTheBlank.new(:content => "Once day I was {travel|travelling} on the {s[tr]eet} seeing a {girl} washing her stuff")
  end
  describe "answer" do
    it "should return the answers without the markup" do
      @fib.answer.should == "travelling, street, girl"
    end
  end
  describe "segments" do
    it "should return all the segments in format of type, and text or text" do
      @fib.segments.should == [{:type => "text", :text => "Once day I was "},
        {:type => "input", :hint => "travel", :no_highlight => true, :answer => "travelling"},
        {:type => "text", :text => " on the "},
        {:type => "input", :hint => "*tr***", :answer => "street"},
        {:type => "text", :text => " seeing a "},
        {:type => "input", :hint => "****", :answer => "girl"},
        {:type => "text", :text => " washing her stuff"}]
    end
  end

  describe "preview" do
    it "should return all parts and trim down critial part" do
      @fib.preview.should == "Once day I was (travel) on the (*tr***) seeing a (****) washing her stuff" 
    end
  end
end
