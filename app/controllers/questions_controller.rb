class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    question = Question.find(params[:id])
    if question.data.is_a?(MultipleChoice)
      redirect_to multiple_choice_path(question.data)
    end
  end

  def edit
    question = Question.find(params[:id])
    if question.data.is_a?(MultipleChoice)
      redirect_to edit_multiple_choice_path(question.data)
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to(questions_path)
  end
end
