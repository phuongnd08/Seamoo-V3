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

  describe "gravatar_url" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should start with http" do
      @user.gravatar_url.should be_starts_with("http://")
    end

    it "should contains indicator of size" do
      @user.gravatar_url(:size => 40).should include("&s=40")
    end
  end

  describe "age" do
    before(:each) do
      @user = Factory(:user, :date_of_birth => 10.years.ago)
    end
    it "should return offset between year of birth and current year" do
      @user.age.should == 10  
    end
  end
end
