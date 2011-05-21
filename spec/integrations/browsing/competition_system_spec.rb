require 'spec_helper'

describe "Competition System" do
  before(:each) do
    @math = Factory(:category, :name => "MathC", :status => "coming_soon")
    @english = Factory(:category, :name => "EnglishC")
    @level0= Factory(:league, :category => @english, :name => "Eng0", :level => 0)
    @level1= Factory(:league, :category => @english, :name => "Eng1", :level => 1)
    @level2= Factory(:league, :category => @english, :name => "Eng2", :level => 2, :status => "coming_soon")
  end
  describe "home page" do
    it "should show all categories but block access to inaccessible category" do
      visit root_path
      page.should have_content("EnglishC")
      page.should have_content("MathC")
      path_of(page.find_link("EnglishC")[:href]).should == category_path(@english)
      page.should have_no_xpath(XPath::HTML.link("MathC"))
      within "##{@math.dom_name}" do
        page.should have_css(".coming_soon")
      end
    end
  end

  describe "category page" do
    it "should show all leagues of a category but block access to inaccessible league" do
      visit category_path(@english)
      ["Eng0", "Eng1", "Eng2"].each{|name| page.should have_content(name)}
      path_of(page.find_link("Eng0")[:href]).should == league_path(@level0)
      page.should have_no_xpath(XPath::HTML.link("Eng2"))
      within "##{@level2.dom_name}" do
        page.should have_css(".coming_soon")
      end
    end
  end

  describe "league page" do
    describe "Not logged in user" do
      it "should remind user to login to match" do
        Informer.logout = true
        visit league_path(@level0)
        page.should have_content "Please signin to compete with other members"    
        page.should have_no_xpath(XPath::HTML.link("Compete"))
        within "##{@level0.dom_name}" do
          path_of(page.find_link("signin")[:href]).should == signin_path
        end
      end
    end

    describe "Logged user" do
      before(:each) do
        @mike = Factory(:user, :display_name => "mike")
        Informer.login_as = "mike"
      end
      describe "unqualified" do
        before(:each) do
          @mike.stub(:qualified_for?).and_return(false)
        end
        it "should tell user to go and prove himself in other leagues" do
          visit league_path(@level1)
          within "##{@level1.dom_name}" do
            page.should have_no_xpath(XPath::HTML.link("Compete"))
            page.should have_content("You are not qualified for this league")
            page.should have_content("Please prove that you are qualified for this league by earning 1000 rank score")
            page.should have_content("in league Eng0")
            path_of(page.find_link("Eng0")[:href]).should == league_path(@level0)
          end
        end
      end

      describe "qualified" do
        before(:each) do
          @mike.membership_in(@level0).update_attributes(:matches_count => 1, :matches_score => 1000)
        end

        it "should allow user to match" do
          visit league_path(@level1)
          within "##{@level1.dom_name}" do
            page.should have_content("You are qualifed")
            path_of(page.find_link("Compete")[:href]).should == matching_league_path(@level1)
          end
        end

        it "should not say 'You are qualifed' for level 0 league" do
          visit league_path(@level0)
          within "##{@level0.dom_name}" do
            page.should have_no_content("You are qualifed")
            path_of(page.find_link("Compete")[:href]).should == matching_league_path(@level0)
          end
        end
      end
    end
  end
end
