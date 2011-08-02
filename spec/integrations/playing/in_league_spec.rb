require 'spec_helper'

describe "in league playing", :js => true, :caching => true, :asynchronous => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league_with_questions)
    MatchingSettings.stub(:started_after).and_return(0) #all match started immediately
    @match = start_match(@league, [@mike, @peter])
  end

  context "normal flow" do
    it "should report status correctly" do
      within "#status" do
        page.should have_content("There are")
        page.should have_content("seconds left")
      end

      within "#question" do
        page.should have_content("Question 1/3")
        page.should have_content(@match.questions[0].data.content)
      end

      assert_player_indicator(@mike, 0, 3)
      assert_player_indicator(@peter, 0, 3)

      click_button("Option #a")
      within "#question" do
        page.should have_content("Question 2/3")
        page.should have_content(@match.questions[1].data.content)
      end

      assert_player_indicator(@mike, 1, 3)
      @match.match_user_for(@peter).add_answer(2, nil)
      assert_player_indicator(@peter, 3, 3)

      click_button("Option #b")
      within "#question" do
        page.should have_content("Question 3/3")
        page.should have_content(@match.questions[2].data.content)
      end
      click_button("Option #a")

      wait_for_true do
        path_of(current_url) == match_path(@match)
      end
    end
  end

  context "no one finish the match" do
    it "should route user to result page in the end" do
      @match.update_attribute(:formed_at, (MatchingSettings.started_after + MatchingSettings.duration).seconds.ago)
      page.execute_script("window.remainedTime = 0"); # force match status check
      wait_for_value match_path(@match) do
        current_path
      end
    end
  end

  context "there is a fast bird" do
    it "timer should count to 0 then switch to result page" do
      @match.match_user_for(@mike).update_attributes(:current_question_position => MatchingSettings.questions_per_match - 1)
      visit matching_league_path(@league)
      within "#question" do
        page.should have_content("Question 3/3")
        click_on "Option #a"
      end

      within "#status" do
        page.should have_content("You have finished the match")
      end

      @match.update_attribute(:formed_at, (MatchingSettings.started_after + MatchingSettings.duration).seconds.ago)
      page.execute_script("window.remainedTime = 0"); # force match status check

      wait_for_value match_path(@match) do
        current_path
      end
    end
  end

  context "leave and go back" do
    it "should route user to new match" do
      click_button("Leave current match")
      page.driver.browser.switch_to.alert.accept
      current_path.should == league_path(@league)
      visit matching_league_path(@league)
      within "#status" do
        page.should have_content("Waiting for other players")
      end
    end
  end

  context "match again" do
    before(:each) do
      @match.update_attribute(:finished_at, Time.now)
    end
    it "should send user to new match" do
      visit matching_league_path(@league)
      page.should have_content("You have finished the match")
      current_path.should == matching_league_path(@league)
    end
  end
end
