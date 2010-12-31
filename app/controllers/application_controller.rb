class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to signin_path(:return_url => request.fullpath)
      return false
    end
  end

  helper_method :current_user

  public

  def set_return_url(return_url)
    session[:return_url] = return_url
  end

  def get_and_reset_return_url
    session[:return_url] || root_path
  ensure
    session[:return_url] = nil
  end
end
