require 'spec_helper'
describe "Authorization" do
  before(:each) do
    OmniAuth.config.test_mode = true
  end

  after(:each) do
    OmniAuth.config.test_mode = false
  end
  describe "using Google" do
    before(:each) do
      OmniAuth.config.mock_auth[:open_id] = @hash = {
        "provider" => "open_id",
        "uid" => "http://google.com/openid?id=test",
        "user_info" => {
          "email" => "test@google.com",
          "name"=> "Test User"
        }
      }
      visit signin_path
    end

    describe "First Time" do
      it "should welcome user for first time and persist authorization hash" do
        click_link("Google")
        page.find_link("Test User").should_not be_nil
        page.should have_content("Welcome to dautri.net, Test User")
        user = User.find_by_display_name_and_email("Test User", "test@google.com")
        user.should_not be_nil
        user.authorizations.first.omniauth.should == @hash
      end
    end

    describe "Second Time" do
      it "should welcome user back" do
        User.create(:email => "test@google.com", :display_name => "Test User").
          authorizations.create(:provider => "open_id", :uid => "http://google.com/openid?id=test")
        click_link("Google")
        page.should have_content("Welcome back, Test User")
      end
    end

    describe "Using emails that already exists" do
      it "should notify user gratefully", :js => true do
        User.create(:email => "test@google.com", :display_name => "Test_User").
          authorizations.create(:provider => "some_provider", :uid => "some uid")
        click_link("Google")
        page.should have_content("Cannot log you in because email test@google.com is already registered for another user. Perhaps it's just you, but in different service (Facebook/Google). Please try again")
        current_path.should == signin_path
      end
    end
  end

  describe "using Facebook" do
    before(:each) do
      OmniAuth.config.mock_auth[:facebook] = @hash = {
        "user_info"=>{
          "name" => "Test User",
          "email" => "test@facebook.com",
          "urls" => {"Facebook"=>"http://www.facebook.com/test", "Website"=>nil},
          "image" => "http://graph.facebook.com/test/picture?type=square"
        }, 
        "extra" => {
          "user_hash" => {
            "birthday" => "01/01/1990"
          }
        },
        "uid" => "http://www.facebook.com/test",
        "provider" => "facebook"
      }

      visit signin_path
    end

    describe "First Time" do
      it "should welcome user for first time and save authorization hash" do
        click_link("Facebook")
        page.find_link("Test User").should_not be_nil
        page.should have_content("Welcome to dautri.net, Test User")
        user = User.find_by_display_name_and_email("Test User", "test@facebook.com")
        user.should_not be_nil
        user.date_of_birth.should == Date.new(1990, 1, 1)
        user.authorizations.first.omniauth.should == @hash
      end
    end

    describe "Second Time" do
      it "should welcome user back", :js => true do
        User.create(:email => "test@facebook.com", :display_name => "Test User").
          authorizations.create(:provider => "facebook", :uid => "http://www.facebook.com/test")
        click_link("Facebook")
        page.should have_content("Welcome back, Test User")
      end
    end
  end
end
