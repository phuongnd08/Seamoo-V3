require 'spec_helper'

describe "categories/index.html.haml" do
  before(:each) do
    assign(:categories, [
      stub_model(Category,
        :name => "Name",
        :description => "Description"
      ),
      stub_model(Category,
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of categories" do
    render
    rendered.should have_selector("tr>td", :content => "Name", :count => 2)
    rendered.should have_selector("tr>td", :content => "Description", :count => 2)
  end
end
