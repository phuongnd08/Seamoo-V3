require 'spec_helper'

describe "Matching Result" do
  def correct_answer(multiple_choice)
    multiple_choice.options.find_index{ |o| o.correct }
  end

  def add_answers(match, user, correct, count)
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
    match_user.save!
  end

  before(:each) do
    @mike = Factory(:user, :display_name => "mike")
    @peter = Factory(:user, :display_name => "peter")
    @eric = Factory(:user, :display_name => "eric")
    @admin = Factory(:admin, :display_name => "admin")
    @match = Factory(:match)
    @match.users << @mike
    @match.users << @peter
    add_answers(@match, @mike, true, 1)
    add_answers(@match, @peter, true, 2)
    add_answers(@match, @peter, false, 1)
  end

  describe "display with regards to viewer" do
    describe "players of match" do
      before(:each) do
        Informer.login_as = "peter"
        visit match_path(@match)
      end
      it "should show player as 'you'" do
        page.should have_content "You (peter) - 67% correct"
        page.should have_content "mike - 33% correct"
        @match.questions.each_with_index do |question, index|
          page.should have_content question.data.content
          case index
          when 0
            page.should have_content "You: #{question.data.options.first.content} - correct"
            page.should have_content "mike: #{question.data.options.first.content} - correct"
          when 1
            page.should have_content "You: #{question.data.options.first.content} - correct"
            page.should have_content "mike: not answered"
          when 2
            page.should have_content "You: #{question.data.options.last.content} - incorrect"
            page.should have_content "mike: not answered"
            page.should have_content "correct answer: #{question.data.options.first.content}"
          end
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
            page.should have_content question.data.content
            case index
            when 0
              page.should have_content "peter: correct"
              page.should have_content "mike: correct"
            when 1
              page.should have_content "peter: correct"
              page.should have_content "mike: not answered"
            when 2
              page.should have_content "peter: incorrect"
              page.should have_content "mike: not answered"
              page.should_not have_content "correct answer: #{question.data.options.first.content}"
            end
          end
        end
      end

      describe "admin user" do
        before(:each) do
          Informer.login_as = "admin"
          visit match_path(@match)
        end

        it "should display all detailed answers and link to edit question" do
          @match.questions.each_with_index do |question, index|
            page.should have_content question.data.content
            case index
            when 0
              page.should have_content "peter: #{question.data.options.first.content} - correct"
              page.should have_content "mike: #{question.data.options.first.content} - correct"
              within "#question_#{question.id}" do
                link = page.find_link("Edit")
                link.should_not be_nil
                path_of(link[:href]).should == edit_question_path(question)
              end
            when 1
              page.should have_content "peter: #{question.data.options.first.content} - correct"
              page.should have_content "mike: not answered"
            when 2
              page.should have_content "peter: #{question.data.options.last.content} - incorrect"
              page.should have_content "mike: not answered"
              page.should have_content "correct answer: #{question.data.options.first.content}"
            end
          end
        end
      end
    end
  end
end
