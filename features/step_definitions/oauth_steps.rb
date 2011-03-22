Given /^I am recognized as open id user "([^"]*)" at "([^"]*)"$/ do |name, provider|
  id = name.split(" ").join(".").downcase
  first_name, last_name = name.split(" ")
  OmniAuth.config.mock_auth[:open_id] = {
    "provider" => "open_id",
    "uid" => "http://#{provider.downcase}.com/openid?id=#{id}",
    "user_info" => {
      "email" => "#{id}@#{provider.downcase}.com", 
      "first_name" => first_name, 
      "last_name" => last_name,
      "name"=> name
    }
  }
end

Given /^I am recognized as facebook user "([^"]*)"$/ do |name|
  id = name.split(" ").join(".").downcase
  first_name, last_name = name.split(" ")
  OmniAuth.config.mock_auth[:facebook] = {
    "user_info"=>{
      "name" => name,
      "last_name" => last_name,
      "first_name" => first_name,
      "email" => "#{id}@fbmail.com"
    }, 
    "uid" => id,
    "provider" => "facebook"
  }
end
