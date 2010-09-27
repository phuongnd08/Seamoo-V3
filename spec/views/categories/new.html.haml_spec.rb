require 'spec_helper'

describe "categories/new.html.haml" do
  before(:each) do
    assign(:category, stub_model(Category,
      :new_record? => true,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new category form" do
    render

    rendered.should have_selector("form", :action => categories_path, :method => "post") do |form|
      form.should have_selector("input#category_name", :name => "category[name]")
      form.should have_selector("input#category_description", :name => "category[description]")
    end
  end
end
