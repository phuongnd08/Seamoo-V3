require 'spec_helper'

describe "follow_patterns/show.html.haml" do
  before(:each) do
    @follow_pattern = assign(:follow_pattern, stub_model(FollowPattern,
      :instruction => "MyInstruction",
      :pattern => "MyPattern"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyInstruction/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyPattern/)
  end
end
