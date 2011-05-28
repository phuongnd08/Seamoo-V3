class LeaguesController < ApplicationController
  before_filter :require_user, :only => [:matching, :request_match_info]
  before_filter :load_league, :except => [:index]
  before_filter :load_active_players, :only => [:matching, :active_players]

  def show
    @membership = @league.memberships.paginate :per_page => Membership.per_page, :page => params[:page], :order => 'rank_score DESC'
  end

  def matching; 
    @use_formulae = @league.use_formulae
  end

  def request_match
    match = @league.request_match(current_user.id) 
    respond_to do |format|
      format.json{
        render :json => {
          :@@status => League.send(:class_variable_get, '@@status'), 
          :match_id => match.try(:id),
        }
      }
    end
  end

  def leave_current_match
    @league.leave_current_match(current_user.id)
    redirect_to league_path(@league)
  end

  def active_players
    render :json => secured_players(@active_players)
  end

  protected
  def load_league
    @league = League.find(params[:id]) 
  end

  def load_active_players
    @active_players = Hash[User.find(@league.active_users.map{|u| u[:id]}).
      map{|u| [u.email_hash, u]}]
  end

  def secured_players(hash)
    hash.merge(hash){|email_hash, u| {:avatar_url => u.gravatar_url, :display_name => u.display_name}}
  end

  helper_method :secured_players
end
