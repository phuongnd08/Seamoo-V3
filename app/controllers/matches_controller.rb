class MatchesController < ApplicationController
  before_filter :load_match, :except => [:index]
  before_filter :require_user, :only => [:register, :submit_answer_and_get_next_question]

  def index
    @matches = Match.all
  end

  def show
    if @match.finished?
      @show_admin_link = current_user.try(:admin)
      @hide_all_answers = !@show_admin_link && @match.users.exclude?(current_user)
      unless @hide_all_answers
        @match.match_users.detect{|mu| mu.user == current_user}.try(:record!)
      end
      @use_formulae = @match.league.use_formulae
    else
      flash[:error] = t("matches.show.details_not_available")
      redirect_to @match.league
    end
  end

  def register
    respond_to do |format|
      format.json{
        render :json => if @match.subscribe(current_user)
        @match.summary.merge :current_question_position => @match.match_user_for(current_user).try(:current_question_position)
    else
      nil
    end
      }
  end
  end

  def brief
    render :json => @match.brief
  end

  def more_questions
    respond_to do |format|
      format.json do
        loaded = params[:loaded].to_i
        max = [loaded + MatchingSettings.questions_per_cache_block - 1, @match.questions.count - 1].min
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
    @match.match_user_for(current_user).
      add_answer(params[:position].to_i, params[:answer])
    render :json => {:successful => true}
  end

  def unsubscribe
    @match.unsubscribe(current_user)
    redirect_to @match.league
  end

  protected

  def load_match
    @match = Match.find(params[:id])
  end

end
