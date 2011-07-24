require 'spec_helper'

describe MatchUser do
  describe "relationships" do
    it {should belong_to(:user)}
    it {should belong_to(:match)}
  end

  describe "method visibility" do
    it "should protect current_question_postion= method" do
      @match_user = MatchUser.new(:match => @match)
      @match_user.protected_methods.should include(:current_question_position=)
    end
  end

  describe "deal with questions" do
    before(:each) do
      #create the match with 3 questions
      @match = Factory(:match)
      @match.fetch_questions!
      @user = Factory(:user)
      @match_user = MatchUser.new(:match => @match, :user => @user)
    end

    describe "answers" do
      it "should default to empty hash" do
        MatchUser.new.answers.should == {}
      end

      it "should retains assigned value after persisted" do
        @match_user = MatchUser.new
        @match_user.answers = {1 => "0"}
        @match_user.save!
        @match_user.reload.answers.should == {1 => "0"}
      end
    end

    describe "add_answer" do
      before(:each) do
        Services::PubSub.stub(:publish)
      end

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

      it "should update user info to match channel" do
        Services::PubSub.should_receive(:publish).with(
          "/matches/#{@match.id}",
          {
            :type => :player_update,
            :user => { :id=> @user.id, :current_question_position=>1 }
          }
        )
        @match_user.add_answer(0, 'abc')
      end
    end

    describe "finished" do
      it "should return value according to whether finished_at is set" do
        @match_user.finished_at = nil
        @match_user.should_not be_finished
        @match_user.finished_at = Time.now
        @match_user.should be_finished
      end
    end

    describe "current_question" do
      it "should return according to current_question_position" do
        @match_user.current_question_position= 0
        @match_user.current_question.should == @match.questions[0]
        @match_user.current_question_position= 1
        @match_user.current_question.should == @match.questions[1]
      end
    end

    describe "after_save" do
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
    end
    describe "score" do
      before(:each) do
        MatchingSettings.stub(:questions_per_match).and_return(3)
        @match= Factory(:match)
        @match.fetch_questions!
        @user = Factory(:user)
        @match_user = MatchUser.create(:match => @match, :user => @user)
        @match_user.add_answer(0, '0')
        @match_user.add_answer(1, '1')
        @match_user.add_answer(1, '0')
      end

      it "should return the score of the match user in the match" do
        @match_user.score.should == 2
      end

      describe "as percent" do
        it "should return score as percent of max possible score" do
          @match_user.score_as_percent.should == 67
        end
      end
      describe "record!" do
        before(:each) do
          @membership = Membership.create(:user => @user, :league => @match.league)
        end
        describe "when not recorded" do
          before(:each) do
            @match_user.record!
          end

          it "should mark itself as recorded" do
            @match_user.reload.recorded.should be_true
          end

          it "should change user membership score" do
            @membership.reload
            @membership.matches_count.should == 1
            @membership.matches_score.should == 67
          end
        end

        describe "when recorded" do
          before(:each) do
            @match_user.recorded = true
            @match_user.record!
          end
          it "should not change user membership score" do
            @membership.reload
            @membership.matches_count.should == 0
            @membership.matches_score.should == 0
          end
        end
      end
    end
  end
end
