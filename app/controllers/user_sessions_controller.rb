class UserSessionsController < Devise::SessionsController
  layout 'login'

  def new
    @errors = true if session[:logged]
    session[:logged] = true
  end
end
