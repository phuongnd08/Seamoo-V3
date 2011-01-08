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