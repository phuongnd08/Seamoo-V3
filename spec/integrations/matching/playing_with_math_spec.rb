require 'spec_helper'

describe 'matching_use_math', :memcached => true, :js => true do
  before(:each) do
    @mike = Factory(:user, :display_name => "mike", :email => "mike@gmail.com")
    @peter = Factory(:user, :display_name => "peter", :email => "peter@gmail.com")
    @league = Factory(:league_with_questions, :use_formulae => true)
    Question.all[0].data.update_attributes!(:content => "Formulae: $\\lambda \\omega$")
    Question.all[0].data.options[0].update_attributes!(:content => "Option $\\sigma$")
    Question.all[1].data.update_attributes!(:content => "Formulae: $\\Pi$")
    Matching.started_after #trigger settings class initialization
    Matching.stub(:started_after).and_return(0) #all match started immediately
    # let mike and peter match on the league
    [@mike, @peter, @mike].each_with_index do |user, index|
      # use 3 default questions in order
      if index==2
        match = @league.matches.first
        Rails.logger.warn("But first league match is nil") if match.nil?
        match.questions.clear
        Matching.questions_per_match.times.each do |i|
          match.questions << Question.all[i]
        end
      end

      Informer.login_as = user.display_name
      visit matching_league_path(@league)
      within "#status" do
        if index==0
          page.should have_content "Waiting for other players"
        else
          page.should have_content "Match started" if index!=0
        end
      end
    end
  end

  it "should render formulae" do
    page.should have_content("Formulae: λω")
    page.should have_content("Option σ")
    click_button("Option σ")
    page.should have_content("Formulae: Π")
  end
end
