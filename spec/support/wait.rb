def wait_for_true(&block)
  wait_for_value(true, &block)
end

def wait_for_value(value)
  saved_wait_time = Capybara.default_wait_time
  Capybara.default_wait_time = 0
  started_at = Time.now
  res = nil
  begin
    res = yield
    sleep 0.5 unless res
  end while (started_at.to_i > saved_wait_time.seconds.ago.to_i && res != value)
  res.should == value
ensure
  Capybara.default_wait_time = saved_wait_time
end
