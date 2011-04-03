class LeaguesController < ApplicationController
  before_filter :require_user, :only => [:matching, :request_match_info]
  before_filter :load_league, :except => [:index]
  before_filter :load_active_players, :only => [:matching, :active_players]
  def index
    @leagues = League.all
  end

  def show
    @membership = @league.memberships.paginate :per_page => Membership.per_page, :page => params[:page], :order => 'rank_score DESC'
  end

  def matching; end

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
    render :partial => 'active_players'
  end

  protected
  def load_league
    @league = League.find(params[:id]) 
  end

  def load_active_players
    real_players = User.find(@league.active_users.map{|u| u[:id]})
    fake_players_count = Matching.fake_active_users_count - Utils::RndGenerator.rnd(Matching.fake_active_users_count / 2)
    fake_players = Utils::RndGenerator.rnd_subset(Matching.bots.each_pair.to_a, fake_players_count)
    fake_hash = Hash[fake_players.map do |name, display_name| 
      u = Bot.new(:email => "#{name}@#{Site.bot_domain}", :display_name => display_name)
      [u.email, u]
    end]
    real_hash = Hash[real_players.map{|u| [u.email, u]}]
    @active_players = Utils::RndGenerator.shuffle(fake_hash.merge(real_hash).values)
  end
end
