# encoding: utf-8
require 'spec_helper'

describe "settings" do
  it "should be automatically loaded" do
    defined?(MatchingSettings).should be_true
    defined?(ServicesSettings).should be_true
    defined?(SiteSettings).should be_true
    defined?(SiteSettings).should be_true
    defined?(DisplaySettings).should be_true
  end

  describe MatchingSettings do
    it "should contain specified accessor" do
      MatchingSettings.started_after.should_not be_nil
      MatchingSettings.duration.should_not be_nil
      MatchingSettings.questions_per_match.should_not be_nil
      MatchingSettings.min_users_per_match.should_not be_nil
      MatchingSettings.max_users_per_match.should_not be_nil
    end
  end
end
