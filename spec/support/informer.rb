class Informer
  class << self
    attr_accessor :login_as
    def reset
      login_as = nil
    end
  end
end

class ApplicationController < ActionController::Base
  prepend_before_filter :set_user
  protected
  def set_user
    if Informer.login_as
      self.send(:activate_authlogic)
      UserSession.create(User.find_by_display_name(Informer.login_as), true)
      #puts "Login as #{Informer.login_as}"
      #Informer.login_as = nil
    end
  end
end
