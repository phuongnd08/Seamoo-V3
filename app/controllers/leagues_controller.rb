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
        match_user = nil
        infor = {}
        infor[:@@status] = League.send(:class_variable_get, '@@status')
        infor[:status] = if match.nil?
                           'waiting'
                         elsif match.finished?
                           'finished'
                         elsif match.started?
                           infor[:seconds_until_ended] = match.seconds_until_ended
                           match_user = match.match_users.find_by_user_id(current_user.id)
                           infor[:current_question_position] = match_user.current_question_position
                           if match_user.finished?
                             'you_finished'
                           else
                             infor[:question] = render_to_string(:partial => "questions/play", :format => :html, 
                                                                 :locals => { :question => match.questions[match_user.current_question_position], 
                                                                   :total_question => match.questions.count, 
                                                                   :current_question_position => match_user.current_question_position })

                           end
                           'started'
                         else
                           infor[:seconds_until_started] = match.seconds_until_started
                           'formed'
                         end

        render :json => infor
      }
    end
  end

  def submit_answer_and_get_next_question
    match = @league.request_match(current_user.id)
    match_user = match.match_users.find_by_user_id(current_user.id)
    match_user.add_answer(params[:position].to_i, params[:answer])   
    match_user.current_question_position = params[:position].to_i + 1
    match_user.save!
    respond_to do |format|
      format.json{
        render :json => unless match_user.finished?
        { :question => render_to_string(:partial => "questions/play", :format => :html, 
                                        :locals => { :question => match.questions[match_user.current_question_position], 
                                          :total_question => match.questions.count, 
                                          :current_question_position => match_user.current_question_position }),
                                          :current_question_position => match_user.current_question_position
        }
    else
      { :status => :you_finished }
    end
      }
  end
end

protected
def load_league
  @league = League.find(params[:id]) 
end
end
