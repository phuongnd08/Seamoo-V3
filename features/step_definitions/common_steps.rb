When /^I fill in last "([^"]*)" with "([^"]*)"$/ do |locator, content|
  all(:xpath, XPath::HTML.fillable_field(locator)).last.set(content)
end

When /^I check last "([^"]*)"$/ do |locator|
  all(:xpath, XPath::HTML.checkbox(locator)).last.set(true)
end

When /^I press to remove choice "([^"]*)"$/ do |choice|
  xpath = "//input[@value='#{choice}']/../a[contains(normalize-space(string(.)), 'Remove')]"
  find(:xpath, xpath).click
end

Given /^\w+ will confirm "([^"]*)"$/ do |msg|
  page.execute_script(%{
    window.confirm = function(msg){
      window.last_confirm_msg = msg;
      return (msg == "#{msg}")
    }
  })
end

Then /^\w+ should( not)? be able to see "([^"]*)"$/ do |negative, selector|
  page.evaluate_script("$('#{selector}').is(':visible')").should == negative.nil?
end

When /^(\w{2,}) go to (.+)$/ do |username, path|
  Informer.login_as = username
  When %{I go to #{path}}
end

Then /^\w+ should( not)? be able to press "([^"]*)"$/ do |negative, button|
  wait_for_true do
    disabled = ["true", "disabled"].include?(find_button(button)[:disabled])
    negative.present? ? disabled : !disabled
  end
end


Then /^\w+ should( not)? be able to edit "([^"]*)"$/ do |negative, field|
  wait_for_true do
    disabled = ["true", "disabled"].include?(find_field(field)[:disabled])
    negative.present? ? disabled : !disabled
  end
end

When /^\w{2,} press "([^"]*)"$/ do |button|
  When %{I press "#{button}"}
end

When /^\w{2,} follow "([^"]*)"$/ do |button|
  When %{I follow "#{button}"}
end

Then /^\w{2,} should be on (.+)$/ do |page|
  Then %{I should be on #{page}}
end

Then /^\w{2,} should soon be on (.+)$/ do |page|
  wait_for_true do
    URI.parse(current_url).path == path_to(page)
  end
end

When /^\w{2,} visit (.+)$/ do |page|
  Then %{I visit #{page}}
end

Then /^\w{2,} should see "([^"]*)"$/ do |text|
  text.split(/\s+[\*\?]\s+/).each do |part|
    Then %{I should see "#{part}"}
  end
end

Then /^\w{2,} should not see "([^"]*)"(.*)$/ do |text, scope_definition|
  Then %{I should not see "#{text}"#{scope_definition}}
end

Given /^question submission is delayed$/ do
  page.execute_script %{
    $.old_ajax = $.ajax;
    $.ajax = function(options){
      if (!/submit_answer$/.test(options.url)) $.old_ajax(options);
    }
  }
end

When /^I should see link "([^"]*)"$/ do |text|
  page.should have_xpath(XPath::HTML.link(text))
end

Then /^"([^"]*)" is not a link$/ do |text|
  page.should have_no_xpath(XPath::HTML.link(text))
end
