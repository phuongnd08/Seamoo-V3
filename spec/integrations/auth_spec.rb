require 'spec_helper'
shared_examples_for "authorize using external provider" do
    before(:each) do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[provider] = omniauth_hash 
      visit signin_path
    end

    after(:each) do
      OmniAuth.config.test_mode = false
    end

    describe "First Time", :js => true do
      it "should welcome user for first time and persist authorization hash" do
        click_link(link_text)
        page.find_link(user_display_name).should_not be_nil
        page.should have_content("Welcome to dautri.net, #{user_display_name}")
        user = User.find_by_display_name_and_email(user_display_name, user_email)
        user.should_not be_nil
        user.authorizations.first.omniauth.should == omniauth_hash
        if birthday.present?
          user.date_of_birth.should == birthday
        end
      end
    end

    describe "Second Time", :js => true do
      it "should welcome user back" do
        User.create(:email => user_email, :display_name => user_display_name).
          authorizations.create(:provider => provider.to_s, :uid => uid)
        click_link(link_text)
        page.should have_content("Welcome back, #{user_display_name}")
      end
    end

    describe "Using emails that already exists", :js => true do
      it "should notify user gratefully" do
        User.create(:email => user_email, :display_name => user_display_name).
          authorizations.create(:provider => "some_provider", :uid => "some uid")
        click_link(link_text)
        page.should have_content("Cannot log you in because email #{user_email} is already registered for another user. Perhaps it's just you, but in different service (Facebook/Google). Please try again")
        current_path.should == signin_path
      end
    end

end


describe "Authorization" do
  describe "using Google" do
    let(:provider){:open_id}
    let(:uid){"http://google.com/openid?id=test"}
    let(:user_email){"test@google.com"}
    let(:user_display_name){"Test User"}
    let(:link_text){"Google"}
    let(:omniauth_hash){
      {
        "provider" => "open_id",
        "uid" => "http://google.com/openid?id=test",
        "user_info" => {
          "email" => "test@google.com",
          "name"=> "Test User"
        }
      }
    }
    let(:birthday){nil}

    it_should_behave_like "authorize using external provider"
  end

  describe "using Facebook" do
    let(:provider){:facebook}
    let(:uid){"http://www.facebook.com/test"}
    let(:user_email){"test@facebook.com"}
    let(:user_display_name){"Test User"}
    let(:link_text){"Facebook"}
    let(:omniauth_hash){
      {
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
    }
    let(:birthday){Date.new(1990, 01, 01)}

    it_should_behave_like "authorize using external provider"
  end

  describe "using Yahoo" do
    let(:provider){:open_id}
    let(:uid){"https://me.yahoo.com/test"}
    let(:user_email){"test@yahoo.com"}
    let(:user_display_name){"Test User"}
    let(:link_text){"Yahoo"}
    let(:omniauth_hash){
      {
        "user_info" => {
          "name" => "Test User",
          "nickname" => "Mr Test", 
          "email" => "test@yahoo.com"
        }, 
        "uid" => "https://me.yahoo.com/test", 
        "provider" => "open_id"
      }
    }
    let(:birthday){nil}

    it_should_behave_like "authorize using external provider"
  end
end
