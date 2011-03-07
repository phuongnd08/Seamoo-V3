def wait_for_true
  saved_wait_time = Capybara.default_wait_time
  Capybara.default_wait_time = 0
  started_at = Time.now
  res = nil
  begin
    res = yield
    if !res
      sleep 0.5
    end
  end while (started_at < saved_wait_time.seconds.ago && !res)
  res
ensure
  Capybara.default_wait_time = saved_wait_time
end

