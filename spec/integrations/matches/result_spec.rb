require 'spec_helper'

shared_examples_for "links back to league" do
  it "should show an exit back to league" do
    visit match_path(@match)
    page.should have_content("Or return to " + @match.league.name)
    page.find_link(@match.league.name)[:href].should == league_path(@match.league)
  end
end

shared_examples_for "show question full details" do
  it "should show details of question and answer" do
    page.should have_content "#{user1} - 50% correct"
    page.should have_content "#{user2} - 33% correct"
    @match.questions.each_with_index do |question, index|
      page.should have_content question.data.preview unless index==1 # question#1 contains image and thus not satisfy this
      case index
      when 0
        page.should have_content "#{user1}: #{question.data.options.first.content} - correct"
        page.should have_content "#{user2}: #{question.data.options.first.content} - correct"
      when 1
        page.should have_content "#{user1}: #{question.data.options.last.content} - incorrect"
        page.should have_content "#{user2}: not answered"
      when 2
        page.should have_content "#{user1}: blank1, - partially correct"
        page.should have_content "#{user2}: not answered"
        page.should have_content "correct answer: #{question.data.answer}"
      end
    end
  end
end

describe "Matching Result" do
  def correct_answer(multiple_choice)
    multiple_choice.options.find_index{ |o| o.correct }
  end

  def add_answers(match, user, correct, count = 1)
    match_user = match.match_users.where(:user_id => user.id).first
    count.downto(1) do 
      question = match_user.current_question
      multiple_choice = question.data
      answer = if correct
                 correct_answer(multiple_choice)
               else 
                 ((0...multiple_choice.options.size).to_a - [correct_answer(multiple_choice)]).first
               end
      match_user.add_answer(match_user.current_question_position, answer.to_s)
    end
  end

  before(:each) do
    @mike = Factory(:user, :display_name => "mike")
    @peter = Factory(:user, :display_name => "peter")
    @eric = Factory(:user, :display_name => "eric")
    @admin = Factory(:admin, :display_name => "admin")
    @match = Factory(:match)
    @match.update_attributes(:questions => [@match.questions.first, Factory(:question_with_image), Factory(:fill_in_the_blank_question)])
    @match.users << @mike
    @match.users << @peter
    add_answers(@match, @mike, true)
    add_answers(@match, @peter, true)
    add_answers(@match, @peter, false)
    muf_peter = @match.match_user_for(@peter)
    muf_peter.add_answer(muf_peter.current_question_position, "blank1, ")
  end

  describe "multimedia" do
    before(:each) do
      visit match_path(@match)
    end

    it "should display images" do
      page.should have_css("img[src='/images/logo.png']")
    end
  end

  describe "display with regards to viewer" do
    describe "players of match" do
      before(:each) do
        Informer.login_as = "peter"
        visit match_path(@match)
      end
      it_should_behave_like "show question full details" do
        let(:user1){"You"}
        let(:user2){"mike"}
      end

      it_should_behave_like "links back to league"

      it "should not show edit link" do
        within "#question_#{@match.questions.first.id}" do
          link = page.should have_no_xpath(XPath::HTML.link("Edit"))
        end
      end
    end
    describe "non-match-player" do
      describe "regular user" do
        before(:each) do
          Informer.login_as = "eric"
          visit match_path(@match)
        end

        it "should display summary but hide all answers" do
          @match.questions.each_with_index do |question, index|
            page.should have_content question.data.preview unless index==1
            case index
            when 0
              page.should have_content "peter: correct"
              page.should have_content "mike: correct"
            when 1
              page.should have_content "peter: incorrect"
              page.should have_content "mike: not answered"
            when 2
              page.should have_content "peter: partially correct"
              page.should have_content "mike: not answered"
              page.should_not have_content "correct answer: #{question.data.answer}"
            end
          end
        end

        it_should_behave_like "links back to league"

        it "should not show edit link" do
          within "#question_#{@match.questions.first.id}" do
            link = page.should have_no_xpath(XPath::HTML.link("Edit"))
          end
        end
      end

      describe "admin user" do
        before(:each) do
          Informer.login_as = "admin"
          visit match_path(@match)
        end

        it_should_behave_like "show question full details" do
          let(:user1){"peter"}
          let(:user2){"mike"}
        end

        it_should_behave_like "links back to league"

        it "should show link to edit question" do
          @match.questions.each_with_index do |question, index|
            within "#question_#{question.id}" do
              link = page.find_link("Edit")
              link.should_not be_nil
              path_of(link[:href]).should == edit_question_path(question)
            end
          end
        end
      end
    end
  end
end
