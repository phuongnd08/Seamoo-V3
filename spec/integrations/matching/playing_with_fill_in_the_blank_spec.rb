require 'spec_helper'

describe "matching with fill in the blank", :js => true, :memcached => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league)
    ["Please {na[m]e1} this", "Please {name|name2} and {name3}", "Also {name4}"].each do |content|
      @league.category.questions << Question.create_fill_in_the_blank(content, :level => 0)
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
      page.evaluate_script(%{$('.hint.#{input_id}').html()}).should == highlight_html
    end
    within "#question" do
      page.should have_content("Question 1/3")
      page.should have_content("**m**")
      inputs = page.all(:css, "input[type=text]")
      inputs.length.should == 1
      inputs.first.set("ans")
      check_hightlight '#question input[type=text]:first', 
                       %{<span class="green">*</span><span class="green">*</span><span class="red">m</span><span class="gray">*</span><span class="gray">*</span>}
      click_button "Submit"
      page.should have_content("Question 2/3")
      page.should have_content("name")
      page.should have_content("*****")
      inputs = page.all(:css, "input[type=text]")
      inputs.length.should == 2
      inputs.first.set("answer2")
      check_hightlight '#question input[type=text]:first', %{<span class="gray">name</span>} 
      inputs.last.set("answer3")
      check_hightlight '#question input[type=text]:last', 
                       %{<span class="green">*</span><span class="green">*</span><span class="green">*</span><span class="green">*</span><span class="green">*</span><span class="purple">r</span><span class="purple">3</span>}
      click_button "Submit"
      page.should have_content("Question 3/3")
      page.should have_content("*****")
      page.should have_no_content("name")
      inputs = page.all(:css, "input[type=text]")
      inputs.length.should == 1
      click_button "ignore"
      assert_recorded_answer("mike", 0, "ans")
      assert_recorded_answer("mike", 1, "answer2, answer3")
      assert_recorded_answer("mike", 2, nil)
    end
  end
end
