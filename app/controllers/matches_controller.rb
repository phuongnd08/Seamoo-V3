class MatchesController < ApplicationController
  before_filter :load_match, :except => [:index]
  before_filter :require_user, :only => [:infor, :submit_answer_and_get_next_question]
  def index
    @matches = Match.all
  end

  def show
  end

  def infor
    respond_to do |format|
      format.json{
        match_user = nil
        infor = {}
        infor[:status] = if @match.finished?
                           infor[:match_result_url] = match_url(@match)
                           :finished
                         elsif @match.started?
                           infor[:seconds_until_ended] = @match.seconds_until_ended
                           match_user = @match.match_users.find_by_user_id(current_user.id)
                           infor[:current_question_position] = match_user.current_question_position
                           if match_user.finished?
                             :you_finished
                           else
                             infor[:question] = render_to_string(:partial => "questions/play", :format => :html, 
                                                                 :locals => { :question => match_user.current_question, 
                                                                   :total_question => @match.questions.count, 
                                                                   :current_question_position => match_user.current_question_position })

                             :started
                           end
                         else
                           infor[:seconds_until_started] = @match.seconds_until_started
                           :formed
                         end

        render :json => infor
      }
    end
  end

  def submit_answer_and_get_next_question
    match_user = @match.match_users.find_by_user_id(current_user.id)
    match_user.add_answer(params[:position].to_i, params[:answer])   
    match_user.save!
    respond_to do |format|
      format.json{
        render :json => unless match_user.finished?
        { :question => render_to_string(:partial => "questions/play", :format => :html, 
                                        :locals => { :question => match_user.current_question, 
                                          :total_question => @match.questions.count, 
                                          :current_question_position => match_user.current_question_position }),
                                          :current_question_position => match_user.current_question_position
        }
    else
      { 
        :status => :you_finished,
        :seconds_until_ended => @match.seconds_until_ended
      }
    end
      }
  end
end

protected

def load_match
  @match = Match.find(params[:id])
end

end
