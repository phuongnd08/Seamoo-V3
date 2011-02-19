require 'spec_helper'

describe MatchUser do
  describe "relationships" do
    it {should belong_to(:user)}
    it {should belong_to(:match)}
  end

  describe "deal with questions" do
    before(:each) do
      #create the match with 3 questions
      @match = mock_model(Match)
      @match.stub(:questions).and_return(['q0', 'q1', 'q2'])
      @match_user = MatchUser.new(:match => @match)
    end

    describe "add_answer" do
      it "should generate a hash entry" do
        @match_user.add_answer(0, 'abc')
        @match_user.add_answer(2, 'xyz')
        @match_user.answers.should == {0 => 'abc', 2 => 'xyz'}
      end

      it "should update finished_at if answer of last question added" do
        now = Time.now
        Time.stub(:now).and_return(now)
        @match_user.add_answer(0, 'abc')
        @match_user.finished_at.should be_nil
        @match_user.add_answer(2, 'xyz')
        @match_user.finished_at.should == now
      end
    end

    describe "finished" do
      it "should return value according to whether user have reached the last question" do
        @match_user.current_question_position = 0
        @match_user.should_not be_finished
        @match_user.current_question_position = 2
        @match_user.should_not be_finished
        @match_user.current_question_position = 3
        @match_user.should be_finished
      end
    end

    describe "current_question" do
      it "should return according to current_question_position" do
        @match_user.current_question_position = 0
        @match_user.current_question.should == "q0" 
        @match_user.current_question_position = 1
        @match_user.current_question.should == "q1" 
      end
    end
  end
end
