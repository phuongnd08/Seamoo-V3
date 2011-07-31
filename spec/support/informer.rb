class Informer
  class << self
    attr_accessor :logout
    attr_accessor :login_as
    def reset
      login_as = nil
      logout = false
    end
  end
end

module FakeLoginMethods
  def set_user
    if Informer.login_as
      self.send(:activate_authlogic)
      UserSession.create(User.find_by_display_name(Informer.login_as), true)
    elsif Informer.logout
      session.destroy
    end
  end
end

ApplicationController.send(:include, FakeLoginMethods)
ApplicationController.prepend_before_filter :set_user
