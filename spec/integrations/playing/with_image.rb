require 'spec_helper'

describe "matching with fill in the blank", :js => true, :memcached => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league)
    @league.category.questions << Question.create_fill_in_the_blank("<img src='/images/logo.png'/>", :level => 0)
    @league.category.questions << Question.create_multiple_choices("<img src='/images/logo.png'/>", {}, :level => 0)
    @league.category.questions << Question.create_follow_pattern("<img src='/images/logo.png'/>", "", :level => 0)
    Matching.started_after #trigger settings class initialization
    Matching.stub(:started_after).and_return(0) #all match started immediately
    # let mike and peter match on the league
    @match = start_match(@league, [@mike, @peter])
  end

  it "should show question and record answer correctly" do
    def assert_image_logo_used
      within ".content" do
        path_of(page.find(:css, "img")[:src]).should == "/images/logo.png"
      end
    end
    within "#question" do
      page.should have_content("Question 1/3")
      assert_image_logo_used
      click_button "ignore"
      page.should have_content("Question 2/3")
      assert_image_logo_used
      click_button "ignore"
      page.should have_content("Question 3/3")
      assert_image_logo_used
    end
  end
end
