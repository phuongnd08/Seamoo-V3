require 'spec_helper'

describe 'edit phuong profile' do
  before(:each) do
    @phuong = Factory(:user, :display_name => "phuong", :email => "phuong@gmail.com", :date_of_birth => 10.years.ago)
    @hung = Factory(:user)
  end

  describe 'as phuong' do
    before(:each) do
      Informer.login_as = @phuong.display_name
      visit edit_user_path(@phuong)
    end

    it "should render proper information by default" do
      within(".edit_user") do
        find_field('user_display_name').value.should == @phuong.display_name
        find_field('user_email').value.should == @phuong.email
        find_field('user_date_of_birth').value.should == @phuong.date_of_birth.strftime('%Y/%m/%d')
      end
    end

    describe "update information" do
      describe "with correct information" do
        before(:each) do
          within(".edit_user") do
            fill_in('user_email', :with => "newemail@gmail.com")
            fill_in('user_date_of_birth', :with => "1990/12/20")
            fill_in('user_display_name', :with => 'new display name')
            click_button('Save')
          end
        end
        it "should allow correct information to be updated" do
          @phuong.reload
          @phuong.email.should == 'newemail@gmail.com' 
          @phuong.display_name.should == "new display name"
          @phuong.date_of_birth.should == Date.new(1990, 12, 20)
        end
        it "should redirect back to user page after update" do
          current_path.should == user_path(@phuong)
        end
      end

      describe "with empty display name" do
        before(:each) do
          within(".edit_user") do
            fill_in('user_display_name', :with => '')
            click_button('Save')
          end
        end
        it "should not successful" do
          @phuong.reload.display_name.should_not be_blank
        end

        it "should render error message" do
          page.should have_content("Display name can't be blank")
        end
      end
    end
  end

  describe 'as different user' do
    before(:each) do
      Informer.login_as = @hung.display_name
      visit edit_user_path(@phuong)
    end
    it "should render forbiden page" do
      page.should have_no_css(".edit_user")
    end
  end
end
