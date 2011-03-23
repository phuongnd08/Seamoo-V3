require 'spec_helper'

describe 'view phuong profile' do
  before(:each) do
    @phuong = Factory(:user, :display_name => "phuong", :email => "phuong@gmail.com", :date_of_birth => 10.years.ago)
    @hung = Factory(:user)
  end

  describe 'as phuong' do
    before(:each) do
      Informer.login_as = @phuong.display_name
      visit user_path(@phuong)
    end
    it "should show user information" do
      within("#info") do
        page.should have_content("Display name phuong")
        page.should have_content("Email phuong@gmail.com")
        page.should have_content("Age 10")
      end
    end

    it "should have a link to edit user information" do
      within("#info") do
        edit_link = page.find(:xpath, XPath::HTML.link("Edit"))
        edit_link.should_not be_nil
        path_of(edit_link[:href]).should == edit_user_path(@phuong)
      end
    end
  end

  describe 'as different user' do
    before(:each) do
      Informer.login_as = @hung.display_name
      visit user_path(@phuong)
    end
    it "should show some user information but not email" do
      within("#info") do
        page.should have_content("Display name phuong")
        page.should have_no_content("Email phuong@gmail.com")
        page.should have_content("Age 10")
      end
    end

    it "should not show a link to edit user information" do
      within("#info") do
        page.should have_no_xpath(XPath::HTML.link("Edit"))
      end
    end
  end
end
