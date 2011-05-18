require 'spec_helper'

describe "Chat" do
  before(:each) do
    @league = Factory(:league)
  end

  describe "not logged in" do
    it "should request user to loggin in" do
      Informer.logout = true
      visit league_path(@league)
      page.should have_content("Please signin to chat")
      within "#chat_need_signin" do
        page.find_link("signin")[:href].should == signin_path
      end
    end
  end

  describe "logged in", :js => true do
    before(:each) do
      Dalli::Client.new("localhost:11211", :namespace => "chat_prod").flush_all
    end
    it "should allow user to send and receive msg" do
      Factory(:user, :display_name => "mike")
      Informer.login_as = "mike"
      visit league_path(@league)
      page.should have_no_content("Please signin to chat")
      pending "Fuck, chat not yet tested because of shit"
      #msg = "Hello world #{Time.now}"
      #within "#chat_form" do
        #fill_in("message", :with => msg)
        #debugger
        #page.execute_script("$('#chat_form').submit()");
        #debugger
      #end
      #within "#chat_box" do
        #page.should have_content(msg)
      #end 
    end
  end
end
