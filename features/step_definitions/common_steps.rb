def wait_for_true(time, die_if_failed = true, &block)
  sleep_time = 0
  while sleep_time < time && !block.call
    sleep 0.1
    sleep_time += 0.1
  end
  block.call.should == true if die_if_failed
end

Given /^I will$/ do |table|
  begin
    wait_time = Capybara.default_wait_time
    Capybara.default_wait_time = 0
    wait_for_true wait_time, false do
      ok = false
      table.hashes.each do |hash|
        if page.has_content?(hash['if I see'])
          Then hash['action'] unless hash['action'].blank?
          ok = true
          break
        end
      end
      ok
    end
  ensure
    Capybara.default_wait_time = wait_time
  end
end

Then /^I should have (\w+)$/ do |type, table|
  clazz = type.capitalize.constantize
  hash = table.hashes.inject({}) do |hs, row|
    hs[row['field'].gsub(/\s+/, '_').downcase.to_sym] = row['value']
    hs
  end
  clazz.find(:first, :conditions => hash).should_not be_nil
end

Given /^I have (\w+)$/ do |type, table|
  clazz = type.capitalize.constantize
  hash = table.hashes.inject({}) do |hs, row|
    hs[row['field'].gsub(/\s+/, '_').downcase.to_sym] = row['value']
    hs
  end
  clazz.create(hash)
end

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
  if negative.present?
    ["true", "disabled"].should include(find_button(button)[:disabled])
  else
    ["true", "disabled"].should_not include(find_button(button)[:disabled])
  end
end


Then /^\w+ should( not)? be able to edit "([^"]*)"$/ do |negative, field|
  if negative.present?
    ["true", "disabled"].should include(find_field(field)[:disabled])
  else
    ["true", "disabled"].should_not include(find_field(field)[:disabled])
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
  wait_for_true Capybara.default_wait_time, false do
    URI.parse(current_url).path == path_to(page)
  end
  Then %{I should be on #{page}}
end

When /^\w{2,} visit (.+)$/ do |page|
  Then %{I visit #{page}}
end

Then /^\w{2,} should see "([^"]*)"(.*)$/ do |text, scope_definition|
  text.split(/\s+[\*\?]\s+/).each do |part|
    Then %{I should see "#{part}"#{scope_definition}}
  end
end

Then /^\w{2,} should not see "([^"]*)"(.*)$/ do |text, scope_definition|
  Then %{I should not see "#{text}"#{scope_definition}}
end


