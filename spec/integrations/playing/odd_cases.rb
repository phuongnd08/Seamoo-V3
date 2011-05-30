require 'spec_helper'

describe "odd cases", :js => true, :memcached => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = prepare_league_for_match
    @match = start_match(@league, [@mike, @peter])
  end

  describe "rejoin after leave" do
    it "should be fine" do
      click_button("Leave current match")
      page.driver.browser.switch_to.alert.accept
      current_path.should == league_path(@league)
      visit matching_league_path(@league)
      within "#status" do
        page.should have_content("Waiting for other players")
      end
    end
  end

  describe "match ended without anyone finished" do
    it "should route user to result page" do
      @match.match_user_for(@mike.id).update_attributes(:current_question_position => Matching.questions_per_match - 1)
      skip_timestamps(Match) do
        @match.update_attribute(:created_at, (Matching.started_after + Matching.ended_after - 3).seconds.ago)
      end
      visit matching_league_path(@league)
      wait_for_value match_path(@match) do
        current_path
      end
    end
  end

  describe "fast bird" do
    it "should see the match count to end then switch to result page" do
      @match.match_user_for(@mike.id).update_attributes(:current_question_position => Matching.questions_per_match - 1)
      visit matching_league_path(@league)
      within "#question" do
        page.should have_content("Question 3/3")
        click_button("Option #a")
      end

      within "#status" do
        page.should have_content("You have finished the match")
      end

      skip_timestamps(Match) do
        @match.update_attribute(:created_at, (Matching.started_after + Matching.ended_after).seconds.ago)
      end

      wait_for_value match_path(@match) do
        current_path
      end
    end
  end
end
