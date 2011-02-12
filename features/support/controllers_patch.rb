class AuthorizationsController
  def signin
    UserSession.create(User.find_by_display_name(params[:username]), true)
    redirect_to root_path
  end
end
