require 'spec_helper'

describe MatchesController do

  def mock_match(stubs={})
    (@mock_match ||= mock_model(Match).as_null_object).tap do |match|
      match.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all matches as @matches" do
      Match.stub(:all) { [mock_match] }
      get :index
      assigns(:matches).should eq([mock_match])
    end
  end

  describe "GET show" do
    it "assigns the requested match as @match" do
      Match.stub(:find).with("37") { mock_match }
      get :show, :id => "37"
      assigns(:match).should be(mock_match)
    end
  end
end
