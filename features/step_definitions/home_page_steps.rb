When /^I am in debug mode$/ do
  puts "BEFORE JUMPING INTO DEBUG"
  require 'ruby-debug'; debugger;
  puts "AFTER JUMPING INTO DEBUG"
end
