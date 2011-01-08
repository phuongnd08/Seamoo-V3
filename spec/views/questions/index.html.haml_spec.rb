require 'spec_helper'

describe "questions/index.html.haml" do
  before(:each) do
    assign(:questions, [
        Question.create_multiple_choices("Who are you", {"a" => false, "b" => false, "c" => false, "d" => true}),
        Question.create_follow_pattern("Your name", "ph[uong]")
      ])
  end

  it "renders a list of questions" do
    render
    rendered.should match(/Who are you/)
    rendered.should match(/Your name/)
  end
end
