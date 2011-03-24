class UsersController < ApplicationController
  before_filter :load_user
  before_filter :require_same_user, :only => [:edit, :update]

  def show
  end

  def edit
  end

  def update
    params[:user][:date_of_birth] = nil if params[:user][:date_of_birth].blank?
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render "edit"
    end
  end

  protected
  def load_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user
      head :forbidden
    end
  end
end
