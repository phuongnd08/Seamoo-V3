def wait_for_true
  saved_wait_time = Capybara.default_wait_time
  Capybara.default_wait_time = 0
  started_at = Time.now
  res = nil
  begin
    res = yield
    sleep 0.5 unless res
  end while (started_at < saved_wait_time.seconds.ago && !res)
  if !res
    debugger
    yield
  end
  res
ensure
  puts "Restore default_wait_time to #{saved_wait_time}"
  Capybara.default_wait_time = saved_wait_time
end

