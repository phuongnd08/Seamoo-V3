module ActionView
  class TestCase < ActiveSupport::TestCase
    class TestController < ActionController::Base
      def default_url_options
        {:locale => I18n.locale}
      end
    end
  end
end

module ActionDispatch
  module Integration
    class Session
      def default_url_options
        {:locale => I18n.locale}
      end
    end
  end
end

