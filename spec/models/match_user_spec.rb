require 'spec_helper'

describe MatchUser do
  describe "relationships" do
    it {should belong_to(:user)}
    it {should belong_to(:match)}
  end

  describe "method visibility" do
    it "should protect current_question_postion= method" do
      @match_user = MatchUser.new(:match => @match)
      @match_user.protected_methods.should include("current_question_position=")
    end
  end

  describe "deal with questions" do
    before(:each) do
      #create the match with 3 questions
      @match = mock_model(Match)
      @match.stub(:questions).and_return(['q0', 'q1', 'q2'])
      @match_user = MatchUser.new(:match => @match)
    end

    describe "add_answer" do# {{{
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

      it "should automatically increase current question position" do
        @match_user.add_answer(0, 'abc')
        @match_user.current_question_position.should == 1
        @match_user.add_answer(2, 'xyz')
        @match_user.current_question_position.should == 3
      end
    end
    # }}}
    describe "finished" do# {{{
      it "should return value according to whether finished_at is set" do
        @match_user.finished_at = nil
        @match_user.should_not be_finished
        @match_user.finished_at = Time.now
        @match_user.should be_finished
      end
    end
    # }}}
    describe "current_question" do# {{{
      it "should return according to current_question_position" do
        @match_user.current_question_position= 0
        @match_user.current_question.should == "q0" 
        @match_user.current_question_position= 1
        @match_user.current_question.should == "q1" 
      end
    end
    # }}}
    describe "after_save" do# {{{
      describe "match user finished" do
        it "should request match to check if it has finished" do
          @match.should_receive(:check_if_finished!)
          @match_user.stub(:finished?).and_return(true)
          @match_user.save
        end
      end

      describe "match user not finished" do
        it "should not request match to check if it has finished" do
          @match.should_not_receive(:check_if_finished!)
          @match_user.stub(:finished?).and_return(false)
          @match_user.save
        end
      end
    end# }}}
    describe "score" do
      it "should return the score of the match user in the match" do
        Matching.stub(:questions_per_match).and_return(3)
        @category = Factory(:category)
        @user = Factory(:user)
        @questions = []
        (1..3).each do |t|
          @questions << Factory(:question, :level => 0, :category => @category)
        end

        @league = League.create!(:level => 0, :category => @category)
        @questions.each{|q| q.data.options[0].update_attribute(:correct, true)}
        match = Match.create(:league => @league)
        match_user = MatchUser.create(:match => match, :user => @user)
        match.questions = Question.all[0..2]
        match.save
        match_user.add_answer(0, '0')
        match_user.add_answer(1, '1')
        match_user.add_answer(1, '0')
        match_user.score.should == 2
      end
    end
  end
end
