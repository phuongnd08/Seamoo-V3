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
    saved_wait_time = Capybara.default_wait_time
    Capybara.default_wait_time = 0
    wait_for_true Capybara.default_wait_time, false do
      debugger
      table.hashes.each do |hash|
        if page.has_content?(hash['if I see'])
          Then hash['action'] unless hash['action'].blank?
          return true
        end
      end
    end
  ensure
    Capybara.default_wait_time = saved_wait_time
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
