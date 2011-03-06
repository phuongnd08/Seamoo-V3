require 'spec_helper'

describe FollowPattern do
  describe "hint" do
    it "should substitute desired input with asterisk but do not substitute space" do
      fp = FollowPattern.new(:instruction => "Your name", :pattern => "ph[uong] n[guy]en")
      fp.hint.should == "**uong *guy**"
    end
  end

  describe "answer" do
    it "should return pattern without the markup" do
      fp = FollowPattern.new(:instruction => "Your name", :pattern => "ph[uong] n[guy]en")
      fp.answer.should == "phuong nguyen"
    end
  end
end
