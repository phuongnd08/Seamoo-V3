require 'spec_helper'

describe FillInTheBlank do
  before(:each) do
    @fib = FillInTheBlank.new(:content => "Once day I was [travel|travelling] on the [s{tr}eet] seeing a [girl] washing her stuff")
  end
  describe "answer" do
    it "should return the answers without the markup" do
      @fib.answer.should == "travelling, street, girl"
    end
  end
  describe "parts" do
    it "should return all the parts in format of type, and text or hint" do
      @fib.parts.should == [{:type => "hint", :text => "Once day I was "},
        {:type => "input", :pattern => "travel", :highlight_as_typing => false},
        {:type => "hint", :text => " on the "},
        {:type => "input", :pattern => "*tr***"},
        {:type => "hint", :text => " seeing a "},
        {:type => "input", :pattern => "****"},
        {:type => "hint", :text => " washing her stuff"}]
    end
  end

  describe "preview" do
    it "should return all parts and trim down critial part" do
      @fib.preview.should == "Once day I was (travel) on the (*tr***) seeing a (****) washing her stuff" 
    end
  end
end
