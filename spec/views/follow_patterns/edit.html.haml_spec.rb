require 'spec_helper'

describe "follow_patterns/edit.html.haml" do
  before(:each) do
    @follow_pattern = assign(:follow_pattern, stub_model(FollowPattern,
      :new_record? => false,
      :instruction => "MyText",
      :pattern => "MyText"
    ))
  end

  it "renders the edit follow_pattern form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => follow_pattern_path(@follow_pattern), :method => "post" do
      assert_select "textarea#follow_pattern_instruction", :name => "follow_pattern[instruction]"
      assert_select "textarea#follow_pattern_pattern", :name => "follow_pattern[pattern]"
    end
  end
end
