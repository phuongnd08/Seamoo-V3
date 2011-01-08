require 'spec_helper'

describe "multiple_choices/new.html.haml" do
  before(:each) do
    assign(:multiple_choice, stub_model(MultipleChoice,
      :content => "MyString"
    ).as_new_record)
  end

  it "renders new multiple_choice form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => multiple_choices_path, :method => "post" do
      assert_select "input#multiple_choice_content", :name => "multiple_choice[content]"
    end
  end
end
