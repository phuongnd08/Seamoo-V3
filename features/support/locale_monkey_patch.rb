module ActionDispatch
  module Integration 
    class Session
      alias_method :old_default_url_options, :default_url_options
      def default_url_options
        old_default_url_options.merge :locale => I18n.locale
      end
    end
  end
end
