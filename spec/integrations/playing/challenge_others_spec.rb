require 'spec_helper'

describe "challenge others", :js => true, :memcached => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league)
    ["Please {na[m]e1} this", "Please {name|name2} and {name3}", "Also {name4}"].each do |content|
      @league.category.questions << Question.create_fill_in_the_blank(content, :level => 0)
    end
    MatchingSettings.started_after #trigger settings class initialization
    MatchingSettings.stub(:started_after).and_return(0) #all match started immediately
  end

  describe "User not logged in" do
    before(:each) do
      Informer.logout = true
      visit challenge_league_path(@league, :from_user_id => @mike.id)
    end

    it "should request user to loggin" do
      current_path.should == signin_path
    end
  end

  describe "User logged in as mike" do
    before(:each) do
      Informer.login_as = @peter.display_name
    end

    describe "Challenge not openning" do
      before(:each) do
        Informer.login_as = @peter.display_name
        visit challenge_league_path(@league, :from_user_id => @mike.id)
      end

      it "should inform the challenge is not available" do
        page.should have_content "peter is not challenging others at the moment"
      end
    end
  end
end

