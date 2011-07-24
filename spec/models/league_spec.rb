require 'spec_helper'

describe League do
  describe "relationships" do
    it { should belong_to(:category)}
    it { should have_many(:matches)}
    it { should have_many(:memberships)}
  end

  describe "default values" do
    it "should have desired default values" do
      league = League.new
      league.use_formulae.should be_false
    end
  end

  describe "dynamic accessor", :caching => true do
    before(:each) do
      @league = League.create!(:level => 0)
      @league2 = League.create!(:level => 0)
    end

    it "should be maintained correctly" do
      now = Time.now.to_i
      @league.send(:ticket)[1].set "abc_#{now}"
      @league2.send(:ticket)[1].set "abc2_#{now}"
      @league.send(:ticket)[1].get.should == "abc_#{now}"
      @league2.send(:ticket)[1].get.should == "abc2_#{now}"
    end
  end

  describe "coordinate requests in league", :caching => true do
    before(:each) do
      @users = (1..5).map{|index| Factory(:user)}
      @league = Factory(:league_with_questions)
    end

    describe "match_for" do
      context "user is not in any match" do
        it "should route user to proper match" do
          @league.match_for(@users[0]).id.should == Match.first.id
          @league.match_for(@users[1]).id.should == Match.first.id
          @league.match_for(@users[2]).id.should == Match.first.id
          @league.match_for(@users[3]).id.should == Match.first.id
          @league.match_for(@users[4]).id.should == Match.first.id + 1
        end
      end

      context "match generation thread got stuck" do
        before(:each) do
          @league.send(:ticket_counter).incr
        end
        it "should route user to no match" do
          @league.match_for(@users[0]).should be_nil
        end

        it "should route user to new match after stuck time" do
          now = Time.now
          Time.stub(:now).and_return(now)
          @league.match_for(@users[0]).should be_nil
          Time.stub(:now).and_return(now + (MatchingSettings.stuck_time + 1).seconds)
          @league.match_for(@users[0]).id.should == Match.first.id
        end
      end

      context "user is already in a match" do
        context "user think that match is still joinable" do
          it "should route user to that match" do
            @league.match_for(@users[1]).id.should == Match.first.id
            @league.match_for(@users[1]).id.should == Match.first.id
          end
        end

        context "user doesn't think that match is still joinable" do
          it "should route user to next proper match" do
            @league.match_for(@users[1]).id.should == 1
            @league.match_for(@users[1], true).id.should == 2
          end
        end
      end
    end
  end

  describe "random questions" do
    before(:each) do
      @league = Factory(:league, :level => 0)
      @questions = []
      2.times do |t|
        Factory(:question, :category => @league.category, :level => 1)
      end
      3.times do |t|
        @questions << Factory(:question, :category => @league.category, :level => 0)
      end
    end
    it "should return a list of random questions within level of league" do
      5.times do
        set = @league.random_questions(2).to_set
        set.size.should == 2
        @questions.to_set.should be_superset(set)
      end
      @league.random_questions(3).to_set.should == @questions.to_set
    end
  end

  describe "status" do
    it "should only accept certain values" do
      League.new(:status => "active").should be_valid
      League.new(:status => "coming_soon").should be_valid
      League.new(:status => "else").should_not be_valid
    end
  end

  describe "active" do
    it "should only return active leagues" do
      @active_league = Factory(:league, :status => "active")
      @inactive_league = Factory(:league, :status => "coming_soon")
      League.active.should == [@active_league]
    end
  end

  describe "previous" do
    it "should return league in the same category and of 1 level lower" do
      @level0a = Factory(:league, :category => @category, :level => 0)
      @level0b = Factory(:league, :category => @category, :level => 0)
      @level1 = Factory(:league, :category => @category, :level => 1)
      @level1.previous.should == [@level0a, @level0b]
    end
  end
end
