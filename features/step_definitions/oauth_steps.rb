Given /^I am recognized as open id user "([^"]*)" at "([^"]*)"$/ do |name, provider|
  id = name.split(" ").join(".").downcase
  first_name, last_name = name.split(" ")
  OmniAuth.config.mock_auth[:open_id] = {
    "provider" => provider,
    "uid" => "http://#{provider.downcase}.com/openid?id=#{id}",
    "user_info" => {
      "email" => "#{id}@#{provider.downcase}.com", 
      "first_name" => first_name, 
      "last_name" => last_name,
      "name"=> name
    }
  }
end

Given /^I am logged in Facebook as "([^"]*)"$/ do |account|
  email, password = account.split("/")
  visit "http://www.facebook.com"
  fill_in("email", :with => email)
  fill_in("pass", :with => password)
  click_button("Login")
end
