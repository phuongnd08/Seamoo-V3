require 'spec_helper'

describe "categories/edit.html.haml" do
  before(:each) do
    @category = assign(:category, stub_model(Category,
      :new_record? => false,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit category form" do
    render

    rendered.should have_selector("form", :action => category_path(@category), :method => "post") do |form|
      form.should have_selector("input#category_name", :name => "category[name]")
      form.should have_selector("input#category_description", :name => "category[description]")
    end
  end
end
