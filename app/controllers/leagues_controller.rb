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
    if match
      puts "match.started: #{match.started?}"
    end
    respond_to do |format|
      format.json{
        infor = {
        :status => League.send(:class_variable_get, '@@status') + render_to_string(:partial => "match_status", :format => :html, :locals => {:match => match})
      }

      unless match.nil? || !match.started?
        match_user = match.match_users.find_by_user_id(current_user.id)
        infor[:question] = render_to_string(:partial => "questions/play", :format => :html, 
                                           :locals => { :question => match.questions[match_user.current_question], 
                                             :total_question => match.questions.count, 
                                             :current_question => match_user.current_question })
      end
      render :json => infor
      }
    end
  end

  protected
  def load_league
    @league = League.find(params[:id]) 
  end
end
