class HomeController < ApplicationController
  before_filter :require_user, :only => :secured
  def index
    flash[:notice] = "Test Notice"
    @categories = Category.all
  end

  def secured

  end

end
