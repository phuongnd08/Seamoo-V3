class AuthorizationsController < ApplicationController
  before_filter :require_user, :only => [:destroy]

  def create
    omniauth = request.env['omniauth.auth'] #this is where you get all the data from your provider through omniauth
    provider = omniauth['provider']
    uid = omniauth['uid']
    user_info = {}.merge(omniauth['user_info']).merge((omniauth['extra'] || {})['user_hash'] || {})

    if current_user
      flash[:notice] = "Successfully added #{omniauth['provider']} authentication"
      current_user.authorizations.create(:provider => provider, :uid => uid, :omniauth => omniauth)
    elsif (auth = Authorization.find_by_provider_and_uid(provider, uid))
      flash[:notice] = t "application.welcome_back", :display_name => auth.user.display_name
      UserSession.create(auth.user, true) #User is present. Login the user with his social account
    else
      user = User.create_from_omni_info(user_info)
      if user.valid?
      user.authorizations.create(:provider => provider, :uid => uid, :omniauth => omniauth)
      flash[:notice] = t "application.welcome", :display_name => user.display_name
      UserSession.create(user, true) #Log the authorizing user in.
      else
        if user.errors[:email].present?
          flash[:error] = t "application.signin_error.email_used", :email => user.email
          Rails.logger.warn("Cannot log user in")
          Rails.logger.warn(user.to_yaml)
          Rails.logger.warn(omniauth.to_yaml)
          redirect_to signin_path
          return
        else
          raise "Cannot log you in"
        end
      end
    end

    redirect_to get_and_reset_return_url
  end

  def failure
    flash[:notice] = "Sorry, You didn't authorize"
    redirect_to root_path
  end

  def destroy
    authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{authorization.provider} authentication."
    authorization.destroy
    redirect_to root_path
  end

  if Rails.env == "development"
    def signin
      UserSession.create(User.find_by_display_name(params[:username]), true)
      redirect_to root_path
    end
  end
end
