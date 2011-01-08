require 'spec_helper'

describe "multiple_choices/show.html.haml" do
  before(:each) do
    @multiple_choice = assign(:multiple_choice, stub_model(MultipleChoice,
      :content => "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Content/)
  end
end
