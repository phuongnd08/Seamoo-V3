require 'spec_helper'

describe "League show page" do
  before(:each) do
    Membership.stub(:per_page).and_return(5)
    @league = Factory(:league)
    @users = []
    (1..10).each do |index|
      @user = (index % 2 == 0)? Factory(:user) : Factory(:bot)
      Membership.create(:user => @user, :league => @league, :matches_count => 20, :matches_score => index)
      @users << @user
    end
  end

  describe "default page" do
    before(:each) do
      visit league_path(@league)
    end
    it "should show list of top-performance users" do
      within('#membership') do
        @users[5..9].reverse.each do |user|
          page.should have_content(user.display_name)
        end    
      end
    end

    it "should show paging links" do
      within('#membership .pagination') do
        link = page.find(:xpath, XPath::HTML.link('2'))
        link[:href].should == league_path(@league, :page => 2)
      end
    end
  end

  describe "chatting" do
    describe "for unauthorized user" do
      it "should ask user to login inorder to chat" do
        visit league_path(@league)
        within(".chatting") do
          page.should have_no_css("#chat_form")
          page.should have_content("Please signin to chat")
          path_of(page.find_link("signin")[:href]).should == signin_path
        end
      end
    end
    describe "for authorized user" do
      before(:each) do
        @user = Factory(:user, :display_name => "user")
        Informer.login_as = "user"
        visit league_path(@league)
      end

      it "should allow user to send chat" do
        within(".chatting") do
          page.should have_css("#chat_form")
        end
      end
    end
  end

  describe "page 2" do
    before(:each){ visit league_path(@league, :page => 2)}

    it "should show list of next-good-performance users" do
      @users[0..4].reverse.each do |user|
        page.should have_content(user.display_name)
      end    
    end

    it "should show paging links" do
      within('#membership .pagination') do
        link = page.find(:xpath, XPath::HTML.link('1'))
        link[:href].should == league_path(@league, :page => 1)
      end
    end
  end
end
