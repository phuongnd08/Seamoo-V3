require 'spec_helper'

describe "categories/show.html.haml" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
    rendered.should contain("Description".to_s)
  end
end
