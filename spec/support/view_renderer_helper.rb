module ActionView
  # = Action View Test Case
  class TestCase < ActiveSupport::TestCase
    class TestController < ActionController::Base
      def default_url_options
        {:locale => I18n.locale}
      end
    end
  end
end
