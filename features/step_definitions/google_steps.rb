Given /^I am logged in Google as "([^"]*)"$/ do |account|
  username, password = account.split("/")
  visit "http://docs.google.com/logout"
  visit "https://www.google.com/accounts/ServiceLoginAuth"
  fill_in("Email", :with => username)
  fill_in("Passwd", :with => password)
  click_button("signIn")
  visit "http://www.google.com/ncr"
end