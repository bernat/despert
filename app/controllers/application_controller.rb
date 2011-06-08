class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def render_optional_error_file(status_code)
    status = status_code.to_i
    render :template => "/errors/#{status}.html.erb", :status => status, :layout => 'login.html.erb'
    return
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {redirect_to request.env["HTTP_REFERER"] || root_url, :alert => "Accés no autoritzat"}
      format.js { render :file => "shared/cancan_rescue_from_js", :status => :ok}
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def user_for_paper_trail
    current_user.name if user_signed_in?
  end
end

