require 'spec_helper'

describe ApplicationController do

  describe "get_and_reset_return_url" do
    it "should return the url for first time" do
      controller.set_return_url("abc")
      controller.get_and_reset_return_url.should == "abc"
    end
    
    it "should return root_path for the second time" do
      controller.set_return_url("abc")
      controller.get_and_reset_return_url
      controller.get_and_reset_return_url.should == root_path
    end
  end
end
