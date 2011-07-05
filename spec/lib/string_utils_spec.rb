require 'spec_helper'

describe "string utils" do
  describe "to_b" do
    it "should return proper value" do
      "true".to_b.should be_true
      "1".to_b.should be_true
      "false".to_b.should be_false
      "0".to_b.should be_false    
    end
  end
end
