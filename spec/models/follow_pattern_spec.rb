require 'spec_helper'

describe FollowPattern do
  describe "hint" do
    it "should substitute desired input with asterisk" do
      fp = FollowPattern.new(:instruction => "Your name", :pattern => "ph[uong] n[guy]en")
      fp.hint.should == "ph**** n***en"
    end
  end
end
