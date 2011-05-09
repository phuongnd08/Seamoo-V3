class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  def default_url_options(options={})
    options.merge :locale => I18n.locale
  end

  private

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = if params[:locale].present? && params[:locale] =~ /^(en|vi)$/
                    params[:locale]
                  else; I18n.default_locale; end
  end

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
      flash[:notice] = t "application.need_login"
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
