require 'spec_helper'

describe "follow_patterns/new.html.haml" do
  before(:each) do
    assign(:follow_pattern, stub_model(FollowPattern,
      :instruction => "MyText",
      :pattern => "MyText"
    ).as_new_record)
  end

  it "renders new follow_pattern form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => follow_patterns_path, :method => "post" do
      assert_select "textarea#follow_pattern_instruction", :name => "follow_pattern[instruction]"
      assert_select "textarea#follow_pattern_pattern", :name => "follow_pattern[pattern]"
    end
  end
end
