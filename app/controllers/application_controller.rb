class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user
  before_action :current_user

private

def current_user
  return @current_user if defined?(@current_user)
  @current_user = current_user_session && current_user_session.user
end

def current_user_session
  if defined?(@current_user_session)
    return @current_user_session
  else
    @current_user_session = UserSession.find
  end
end

def require_user
  unless @current_user
    flash[:alert]="You have to be logged in"
    redirect_to root_url
  end
end

def require_no_user
  if @current_user
      flash[:alert]="You are already logged in"
      redirect_to root_url
  end
end

end
