require 'spec_helper'

describe "matches/show.html.haml" do
  before(:each) do
    @match = assign(:match, stub_model(Match,
      :league_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
