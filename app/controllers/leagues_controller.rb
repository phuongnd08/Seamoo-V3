class LeaguesController < ApplicationController
  before_filter :require_user, :only => [:matching, :request_match_info]
  before_filter :load_league, :except => [:index]
  def index
    @leagues = League.all
  end

  def show; end

  def matching; end

  def request_match
    match = @league.request_match(current_user.id) 
    respond_to do |format|
      format.json{
        render :json => {
          :@@status => League.send(:class_variable_get, '@@status'), 
          :match_id => match.try(:id),
          :other_active_players => User.find(@league.active_users.map{|u| u[:id]} - [current_user.id]).
            map{|u| {:display_name => u.display_name}}
        }
      }
    end
  end

  def leave_current_match
    @league.leave_current_match(current_user.id)
    redirect_to league_path(@league)
  end

  protected
  def load_league
    @league = League.find(params[:id]) 
  end
end
