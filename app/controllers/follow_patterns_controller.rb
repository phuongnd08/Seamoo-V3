class FollowPatternsController < ApplicationController
  before_filter :load_follow_pattern, :only => [:show, :edit, :update]

  def show
    @use_formulae = true
  end

  def new
    @follow_pattern = FollowPattern.new
  end

  def edit
  end

  def create
    @follow_pattern = FollowPattern.new(params[:follow_pattern])
    if @follow_pattern.save
      Question.create(:data => @follow_pattern)
      redirect_to(@follow_pattern, :notice => 'Follow pattern was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @follow_pattern.update_attributes(params[:follow_pattern])
      redirect_to(@follow_pattern, :notice => 'Follow pattern was successfully updated.')
    else
      render :action => "edit"
    end
  end

  protected
  def load_follow_pattern
    @follow_pattern = FollowPattern.find(params[:id])
  end
end
