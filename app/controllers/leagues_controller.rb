class LeaguesController < ApplicationController
  before_filter :require_user, :only => [:matching, :request_match_info]
  before_filter :load_league, :except => [:index]

  def show
    @membership = @league.memberships.paginate :per_page => Membership.per_page, :page => params[:page], :order => 'rank_score DESC'
  end

  def matching;
    @use_formulae = @league.use_formulae
  end

  def request_match
    match = @league.match_for(current_user, params[:force])
    respond_to do |format|
      format.json{
        render :json => {
          :match_id => match.try(:id)
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
