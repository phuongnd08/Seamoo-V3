When /^I pause$/ do
  require 'ruby-debug'; debugger;
  1 # pause break point here instead of inside steps runner
end

When /^debugging is turned (on|off)/ do |flag|
  Utils::Informer.debugging = (flag == "on")
end

When /^I wait ([\d\.]+) seconds?$/ do |time|
  sleep time.to_f
end
