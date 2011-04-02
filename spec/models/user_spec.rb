require 'spec_helper'

describe User do
  describe "relationships" do
    it{should have_many(:authorizations)}
    it{should have_many(:links)}
    it{should have_many(:memberships)}
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

  describe "validation" do
    before(:each) { @user = Factory.build(:user) }
    describe "date_of_birth" do
      it "should accept invalid value as nil" do
        @user.date_of_birth = "x"
        @user.date_of_birth.should be_nil
      end

      it "should accept proper date format as correct value" do
        @user.date_of_birth = "2000/12/31"
        @user.date_of_birth.should == Date.new(2000, 12, 31)
      end
    end

    describe "display_name" do
      it "should not accept empty value" do
        @user.display_name = ""
        @user.valid?
        @user.errors[:display_name].should_not be_empty
      end
    end

    describe "email" do
      it "should not accept empty value" do
        @user.email = ""
        @user.valid?
        @user.errors[:email].should_not be_empty
      end
    end
  end

  describe "membership_in" do
    before(:each) do
      @user = Factory(:user) 
      @league1 = Factory(:league) 
      @league2 = Factory(:league) 
      @membership1 = Membership.create(:user => @user, :league=> @league1)
      @membership2 = Membership.create(:user => @user, :league=> @league2)
    end
    it "should return the membership in the given league" do
      @user.membership_in(@league1).should == @membership1
      @user.membership_in(@league2).should == @membership2
    end

    it "should create the membership incase not exists" do
      @user.membership_in(Factory(:league)).should_not be_nil
    end
  end
end
