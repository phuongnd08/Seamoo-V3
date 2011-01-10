class LeaguesController < ApplicationController
  before_filter :require_user, :only => [:subscribe]
  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
  end

  def subscribe
    
  end
end
