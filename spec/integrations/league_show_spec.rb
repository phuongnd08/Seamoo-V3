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

  describe "page 2" do
    it "should show list of next-good-performance users" do
      visit league_path(@league, :page => 2)
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
