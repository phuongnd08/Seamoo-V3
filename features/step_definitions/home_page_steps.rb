Given /^There is a category named "([^"]+)"$/ do |category_name|
  Category.create!(:name => category_name)
end