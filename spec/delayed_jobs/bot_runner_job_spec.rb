require 'spec_helper'

describe BotRunnerJob do
  describe "perform" do
    before(:each) do
      Matching.stub(:bot_life_time).and_return(0)
    end
    it "should ensure that at least 1 more jobs exists" do
      BotRunnerJob.new.perform
      Delayed::Job.count.should == 1
      Delayed::Job.last.name.should == 'BotRunnerJob'
    end

    it "should not increase jobs in db if there are already too many" do
      Delayed::Job.enqueue BotRunnerJob.new
      Delayed::Job.enqueue BotRunnerJob.new
      BotRunnerJob.new.perform
      Delayed::Job.count.should == 2
    end

    describe "adding activity to league" do
      before(:each) do
        @category = Factory(:category)
        @user1 = Factory(:user)
        @user2 = Factory(:user)
        @bot1 = Factory(:bot)
        @questions = []
        (1..3).each do |t|
          @questions << Factory(:question, :level => 0, :category => @category)
        end
        @league = League.create!(:level => 0, :category => @category)
      end

      describe "when a league has no players" do
        it "should awake no bot" do
          BotRunnerJob.new.perform
          Bot.awaken.count.should == 0
        end
      end

      describe "when a league has only 1 player" do
        it "should awake only 1 nonbusy bot" do
          @league.request_match(@user1.id)
          BotRunnerJob.new.perform
          Bot.awaken.count.should == 1
          BotRunnerJob.new.perform
          Bot.awaken.count.should == 1
        end

        it "should cause the bot to leave footprint in league" do
          @league.request_match(@user1.id)
          BotRunnerJob.new.perform
          @league.waiting_users.size.should == 2
          @league.waiting_users.first[:id].should == @user1.id
          @league.waiting_users.first[:bot].should be_false
          @league.waiting_users.last[:id].should == Bot.last.id
          @league.waiting_users.last[:bot].should be_true
        end

        it "should tell the bot which league it should operate on" do
          @league.request_match(@user1.id)
          BotRunnerJob.new.perform
          Bot.last.data[:league_id].should == @league.id
        end
      end
      describe "when a league has footprint of 1 bot" do
        it "should awake no bot" do
          @league.request_match(@bot1.id, true)
          BotRunnerJob.new.perform
          Bot.awaken.count.should == 0
        end
      end

      describe "run bot" do
        it "should run all awaken bot" do
          mock_bot = mock_model(Bot)
          mock_bot.should_receive(:run)
          Bot.stub(:awaken).and_return([mock_bot])
          BotRunnerJob.new.perform
        end
      end
    end
  end
end 
