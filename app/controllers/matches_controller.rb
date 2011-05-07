class MatchesController < ApplicationController
  before_filter :load_match, :except => [:index]
  before_filter :require_user, :only => [:infor, :submit_answer_and_get_next_question]
  def index
    @matches = Match.all
  end

  def show
    @show_admin_link = current_user.try(:admin)
    @hide_all_answers = !@show_admin_link && @match.users.exclude?(current_user)
    unless @hide_all_answers
      @match.match_users.detect{|mu| mu.user == current_user}.try(:record!)
    end
    @use_formulae = @match.league.use_formulae
  end

  def infor
    respond_to do |format|
      format.json{
        match_user = nil
        infor = {}
        infor[:players] = @match.match_users.map{ |mu| 
          { 
            :display_name => mu.user.display_name, 
            :avatar_url => mu.user.gravatar_url,
            :current_question_position => mu.current_question_position
          } 
        }
        infor[:status] = if @match.finished?
                           infor[:match_result_url] = match_url(@match)
                           :finished
                         elsif @match.started?
                           infor[:seconds_until_ended] = @match.seconds_until_ended
                           @match_user ||= @match.match_users.find_by_user_id(current_user.id)
                           infor[:current_question_position] = @match_user.current_question_position
                           if @match_user.finished?
                             :you_finished
                           else
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

  def more_questions
    respond_to do |format|
      format.json do
        loaded = params[:loaded].to_i
        max = [loaded + Matching.questions_per_cache_block - 1, @match.questions.count - 1].min
        json = (loaded..max).map do |index|
          {
            :content => render_to_string(:partial => "questions/play", :format => :html,
                                         :locals => {
                                            :question => @match.questions[index],
                                            :total_question => @match.questions.count,
                                            :current_question_position => index
                                          }),
            :type => @match.questions[index].data.class.name
          }
        end

        render :json => json
      end
    end
  end

  def submit_answer
    @match_user = @match.match_users.find_by_user_id(current_user.id)
    @match_user.add_answer(params[:position].to_i, params[:answer])   
    @match_user.save!
    render :json => {:successful => true}
  end

  protected

  def load_match
    @match = Match.find(params[:id])
  end

end
