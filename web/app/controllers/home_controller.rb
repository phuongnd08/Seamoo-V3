class HomeController < ApplicationController
  before_filter :require_user, :only => :secured
  def index
    @categories = Category.all
  end

  def secured

  end

end
