Given /^There is a league named "([^"]*)" in "([^"]*)"$/ do |league_name, category_name|
  Category.find_by_name(category_name).leagues << League.create(:name => league_name)
end

