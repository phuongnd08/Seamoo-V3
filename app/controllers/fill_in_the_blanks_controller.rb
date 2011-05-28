class FillInTheBlanksController < ApplicationController
  before_filter :load_fill_in_the_blank, :only => [:show, :edit, :update]

  def show
    @use_formulae = true
  end

  def new
    @fill_in_the_blank = FillInTheBlank.new
  end

  def edit
  end

  def create
    @fill_in_the_blank = FillInTheBlank.new(params[:fill_in_the_blank])
    if @fill_in_the_blank.save
      Question.create(:data => @fill_in_the_blank)
      redirect_to(@fill_in_the_blank, :notice => 'Fill in the blank was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @fill_in_the_blank.update_attributes(params[:fill_in_the_blank])
      redirect_to(@fill_in_the_blank, :notice => 'Fill in the blank was successfully updated.')
    else
      render :action => "edit"
    end
  end

  protected
  def load_fill_in_the_blank
    @fill_in_the_blank = FillInTheBlank.find(params[:id])
  end
end
