class AuthorizationsController < ApplicationController
  before_filter :require_user, :only => [:destroy]

  def create
    omniauth = request.env['rack.auth'] #this is where you get all the data from your provider through omniauth
    provider = omniauth['provider']
    uid = omniauth['uid']
    user_info = omniauth['user_info']
    
    if current_user
      flash[:notice] = "Successfully added #{omniauth['provider']} authentication"
      current_user.authorizations.create(:provider => provider, :uid => uid)
    elsif (auth = Authorization.find_by_provider_and_uid(provider, uid))
      flash[:notice] = "Welcome back #{omniauth['provider']} user"
      UserSession.create(auth.user, true) #User is present. Login the user with his social account
    else
      user = User.create_from_omni_info(user_info)
      user.authorizations.create(:provider => provider, :uid => uid)
      flash[:notice] = "Welcome #{omniauth['provider']} user. Your account has been created."
      UserSession.create(user, true) #Log the authorizing user in.
    end

    redirect_to get_and_reset_return_url
  end
  
  def failure
    flash[:notice] = "Sorry, You din't authorize"
    redirect_to root_path
  end
  
  def destroy
    authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{authorization.provider} authentication."
    authorization.destroy
    redirect_to root_path
  end

end
