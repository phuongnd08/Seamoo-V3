require 'spec_helper'

describe "matching with fill in the blank", :js => true, :memcached => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league)
    3.times do |i|
      Question.create_follow_pattern("Follow Pattern \##{i+1}", '[g]o [b]ack', 
                                              :category => @league.category, :level => @league.level)
    end
    Matching.started_after #trigger settings class initialization
    Matching.stub(:started_after).and_return(0) #all match started immediately
    # let mike and peter match on the league
    @match = start_match(@league, [@mike, @peter])
  end

  it "should show question and record answer correctly" do
    def check_hightlight(input_selector, highlight_html)
      input_id = page.evaluate_script(%{$('#{input_selector}').attr('id')})
      page.execute_script(%{$('#{input_selector}').keyup()})
      puts page.evaluate_script(%{$('#hint').html()})
      page.evaluate_script(%{$('#hint').html()}).should == highlight_html
    end
    within "#question" do
      page.should have_content("Question 1/3")
      page.should have_content("Follow Pattern #1")
      page.should have_content("g* b***")
      inputs = page.all(:css, "input[type=text]")
      inputs.length.should == 1
      inputs.first.set("go ba")
      check_hightlight '#question input[type=text]:first', 
                       %{<span class="green">g</span><span class="green">*</span><span class="green">_</span><span class="green">b</span>} +
                       %{<span class="green">*</span><span class="gray">*</span><span class="gray">*</span>}
      click_button "Submit"
      page.should have_content("Question 2/3")
      page.should have_content("Follow Pattern #2")
      click_button "ignore"
      assert_recorded_answer("mike", 0, "go ba")
      assert_recorded_answer("mike", 1, nil)
    end
  end

  it "should focus the input" do
    page.should have_content("Question 1/3")
    page.execute_script("$.fn.focus = function(){ window.focusedElement = this[0]; }")
    click_button "Submit"
    wait_for_true do
      page.evaluate_script("window.focusedElement == $('#question input[type=text]')[0]")
    end
  end
end
