require 'spec_helper'

describe User do
  describe "relationships" do
    it{should have_many(:authorizations)}
  end

  describe "destroy" do
    it "should destroy all related authorizations" do
      user = Factory(:user) 
      User.count.should == 1
      Authorization.count.should == 1

      user.destroy
      User.count.should == 0
      Authorization.count.should == 0
    end
  end
end
