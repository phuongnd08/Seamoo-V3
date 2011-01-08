require 'spec_helper'

describe "multiple_choices/edit.html.haml" do
  before(:each) do
    @multiple_choice = assign(:multiple_choice, stub_model(MultipleChoice,
      :new_record? => false,
      :content => "MyString"
    ))
  end

  it "renders the edit multiple_choice form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => multiple_choice_path(@multiple_choice), :method => "post" do
      assert_select "input#multiple_choice_content", :name => "multiple_choice[content]"
    end
  end
end
