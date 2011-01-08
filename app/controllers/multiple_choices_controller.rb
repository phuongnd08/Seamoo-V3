class MultipleChoicesController < ApplicationController
  before_filter :load_multiple_choice, :only => [:show, :edit, :update, :delete]

  def index
    @multiple_choices = MultipleChoice.all
  end

  def show
  end

  def new
    @multiple_choice = MultipleChoice.new
  end

  def edit
  end

  def create
    @multiple_choice = MultipleChoice.new(params[:multiple_choice])
    if @multiple_choice.save
      @question = Question.create(:data => @multiple_choice)
      redirect_to(@question, :notice => 'Multiple choice was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @multiple_choice.update_attributes(params[:multiple_choice])
      redirect_to(@multiple_choice, :notice => 'Multiple choice was successfully updated.')
    else
      render :action => "edit"
    end
  end

  protected
  def load_multiple_choice
    @multiple_choice = MultipleChoice.find(params[:id].to_i)
    @question = Question.find_by_data_id_and_data_type(@multiple_choice.id, @multiple_choice.class.name)
  end
end
