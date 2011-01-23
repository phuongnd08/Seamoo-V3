module Utils
  module Waiter
    def try_until_not_nil_or_timeout(how_long, interval = 0.1)
      wait = 0
      value = nil
      while (wait < how_long && value == nil) do
        value = yield
        if (value == nil)
          sleep interval
          wait += interval
        end
      end
      value
    end
  end
end
