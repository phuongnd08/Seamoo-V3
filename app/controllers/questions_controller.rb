class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    question = Question.find(params[:id])
    redirect_to question.data
  end

  def edit
    question = Question.find(params[:id])
    redirect_to (send(['edit',  ActiveModel::Naming.singular(question.data), 'path'].join('_'), question.data))
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to(questions_path)
  end
end
