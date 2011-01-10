require 'spec_helper'

describe "matches/index.html.haml" do
  before(:each) do
    assign(:matches, [
      stub_model(Match,
        :league_id => 1
      ),
      stub_model(Match,
        :league_id => 1
      )
    ])
  end

  it "renders a list of matches" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
