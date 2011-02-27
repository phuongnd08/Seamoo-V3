require 'spec_helper'

describe Bot do
  describe "awake new" do
    it "should awake new bot" do
      Matching.stub(:bot_names).and_return(["abc", "xyz"])
      Bot.awake_new
      Bot.awaken.count.should == 1
      Bot.awaken.first.display_name.should == "abc"
      Bot.awake_new
      Bot.awaken.count.should == 2
      Bot.awaken.last.display_name.should == "xyz"
    end

    it "should return the new awakened bot" do
      Matching.stub(:bot_names).and_return(["abc", "xyz"])
      bot = Bot.awake_new
      bot.is_a?(Bot).should be_true
      Bot.find(bot.id).should == bot
    end
  end

  describe "run" do
    before(:each) do
      Matching.stub(:started_after).and_return(5)
      Matching.stub(:bot_time_per_question).and_return(5)
      Matching.stub(:bot_correctness).and_return(0.8)
      Matching.stub(:ended_after).and_return(300)
      Matching.stub(:questions_per_match).and_return(10)
      @category = Factory(:category)
      @questions = []
      (1..10).each do |t|
        question = Factory(:question, :level => 0, :category => @category)
        question.data.options[0].update_attribute(:correct, true)
        @questions << question
      end
      @league = League.create!(:level => 0, :category => @category)
      @bot = Bot.awake_new
      @now = Time.now
      Time.stub(:now).and_return(@now)
      @match = Match.create(:league => @league)
      @bot.data[:match_id] = @match.id
      @match_user = MatchUser.create(:match => @match, :user => @bot)
    end

    it "should answer questions at predefined speed" do
      Time.stub(:now).and_return(@now + 4.seconds)
      @bot.run
      @match_user.reload.current_question_position.should == 0
      Time.stub(:now).and_return(@now + 19.seconds)
      @bot.run
      @match_user.reload.current_question_position.should == 3
      Time.stub(:now).and_return(@now + 59.seconds)
      @bot.run
      @match_user.reload.current_question_position.should == 10
    end

    it "should answer questions at predfined correctness" do
      Time.stub(:now).and_return(@now + 59.seconds)
      Kernel.stub(:rand).and_return(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)
      @bot.run
      @match_user.reload.current_question_position.should == 10
      @match_user.reload.score.should == 8
    end
  end
end
