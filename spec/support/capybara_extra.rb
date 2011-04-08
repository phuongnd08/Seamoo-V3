module CapybaraExtra
  def find_link(text)
    self.find(:xpath, XPath::HTML::link(text))
  end
end
Capybara::Session.send(:include, CapybaraExtra)
