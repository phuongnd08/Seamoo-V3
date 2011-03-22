class UserSessionsController < ApplicationController
  def new
    set_return_url(params[:return_url])
    @user_session = UserSession.new
  end
  
  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy if @user_session
    flash[:notice] = t "application.signed_out"
    redirect_to root_url
  end

end
