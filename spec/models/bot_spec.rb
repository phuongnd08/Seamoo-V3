# encoding: utf-8
require 'spec_helper'

describe Bot, :caching => true do
  describe "avatar" do
    it "should have gravatar like users" do
      Bot.new(:email => "bot@#{SiteSettings.domain}").gravatar_url.should_not be_nil
    end
  end

  describe "new" do
    it "should generate email & display_name based on name if set" do
      Bot.stub(:names).and_return(:all => {"abc" => "User Abc"})
      bot = Bot.new(:name => "abc")
      bot.display_name.should == "User Abc"
      bot.email.should == "abc@#{SiteSettings.bot_domain}"
    end

    it "should not touch email & display_name if name unset" do
      bot = Bot.new
      bot.display_name.should be_blank
      bot.email.should be_blank
    end

    it "should not interfere email & display_name if already set" do
      bot = Bot.new(:name => "abc", :display_name => "Some name", :email => "some_email@domain.com")
      bot.display_name.should == "Some name"
      bot.email.should == "some_email@domain.com"
    end
  end

  describe "names" do
    it "should have correct size" do
      Bot.names.size.should == 3
      (Bot.names[0].size + Bot.names[1].size).should == 100
      Bot.names[:all].size.should == 100
    end

    it "should contains proper key/value pairs" do
      Bot.names[0]["than_dong_daiso"][:display_name].should == "Thần đồng đại số"
      Bot.names[0]["ban_messi"][:display_name].should == "ban_messi"
      Bot.names[1]["r10"][:display_name].should == "r10"
      Bot.names[1]["vo_danh"][:display_name].should == "Vô Danh"
    end
  end

  describe "awake new" do
    before(:each) do
      Bot.stub(:names).and_return(
        {
        0 => {
        "abc" => {:display_name => "Abc User"},
        "xyz" => {:display_name => "xyz"}
      },
        1 => {
        "def" => {:display_name => "def"},
        "tuv" => {:display_name => "tuv"}
      }
      }
      )
    end

    it "should awake new bot correspond to required level" do
      Utils::RndGenerator.stub(:rnd).and_return(1, 0, 0)
      Bot.awake_new(0)
      Bot.awaken.count.should == 1
      Bot.awake_new(0)
      Bot.awaken.count.should == 2
      Bot.awaken.map(&:display_name).to_set.should == ["Abc User", "xyz"].to_set
      Bot.awaken.map(&:email).to_set.should == ["abc@#{SiteSettings.bot_domain}", "xyz@#{SiteSettings.bot_domain}"].to_set
      Bot.awake_new(1)
      Bot.awaken.count.should == 3
      ["def", "tuv"].should include(Bot.awaken.last.display_name)
    end

    it "should return the new awakened bot" do
      bot = Bot.awake_new(0)
      bot.is_a?(Bot).should be_true
      Bot.find(bot.id).should == bot
    end

    it "should reset bot information about past match" do
      #make sure same bot will be reused
      Utils::RndGenerator.stub(:rnd).and_return(1)
      bot = Bot.awake_new(0)
      Bot.kill(bot)
      bot.match_id.set 1
      bot.match_request_retried.set 5
      new_bot = Bot.awake_new(0)
      new_bot.should == bot
      new_bot.match_id.get == nil
      new_bot.match_request_retried.get.to_i.should == 0
    end
  end

  describe "perform" do
    before(:each) do
      MatchingSettings.started_after #trigger settings logic accessor initilization to prevent re-override rspec stub
      MatchingSettings.stub(:started_after).and_return(5)
      MatchingSettings.stub(:bot_time_per_question).and_return(5)
      MatchingSettings.stub(:bot_correctness).and_return(0.8)
      MatchingSettings.stub(:duration).and_return(300)
      MatchingSettings.stub(:questions_per_match).and_return(10)
      @match = Factory(:match)
      @user = Factory(:user)
      @match.subscribe(@user)
      @bot = Bot.awake_new(0)
      @now = Time.now
      Time.stub(:now).and_return(@now)
      Kernel.stub(:sleep)
      Services::PubSub.stub(:publish)
      @match.fetch_questions! # hack, force the match to fetch question first so that stubbed rnd used for answering

      Utils::RndGenerator.stub(:rnd).and_return(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)
      @bot.perform(@match)
    end

    it "should join match" do
      @match.users.should include(@bot)
    end

    it "should answers all questions at predefined correctness" do
      @match_user = @match.match_user_for(@bot)
      @match_user.current_question_position.should == 10
      @match.questions.each do |index|
        @match_user.answers.has_key?(index)
      end
      @match_user.reload.score.should == 8
    end

    it "should die" do
      Bot.awaken.should_not include(@bot)
    end
  end
end
