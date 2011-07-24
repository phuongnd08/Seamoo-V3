require 'spec_helper'

describe "in league playing", :js => true, :caching => true, :asynchronous => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league_with_questions)
    MatchingSettings.stub(:started_after).and_return(0) #all match started immediately
  end

  it "should report status correctly" do
    @match = start_match(@league, [@mike, @peter])

    within "#status" do
      page.should have_content("There are")
      page.should have_content("seconds left")
    end

    within "#question" do
      page.should have_content("Question 1/3")
      page.should have_content(@match.questions[0].data.content)
    end

    def assert_player_indicator(user, position, total)
      within "#match_players" do
        selector = if (position < total)
                     "img[title='#{user.display_name} (#{position+1}/#{total})']"
                   else
                     "img[title='#{user.display_name} (finished)']"
                   end
        page.should have_css(selector)

        img_width = page.evaluate_script(%{$("#match_players #{selector}").width()}).to_f
        lane_width = page.evaluate_script(%{$("#match_players #{selector}").parent("li").width()}).to_f
        margin = position.to_f/total*(lane_width-img_width)
        page.evaluate_script(%{$("#match_players #{selector}").css('marginLeft')}).to_f.should be_within(0.1).of(margin)
      end
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
