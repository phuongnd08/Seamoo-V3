class LeaguesController < ApplicationController
  before_filter :require_user, :only => [:matching, :request_match_info]
  before_filter :load_league, :except => [:index]
  def index
    @leagues = League.all
  end

  def show; end

  def matching; end

  def request_match_info
    match = @league.request_match(current_user.id) 
    respond_to do |format|
      format.json{
        render :json => {
        :status => render_to_string(:partial => "match_status", :format => :html, :locals => {:match => match})
      }
      }
    end
  end

  protected
  def load_league
    @league = League.find(params[:id]) 
  end
end
