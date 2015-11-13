class SessionsController < ApplicationController
  before_action :require_no_user, only: [:new, :create]
  before_action :require_user, only: [:destroy]

  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(session_params)
    if @session.save
      redirect_to user_path, notice: "You're logged in. Rant away!"
    else
      flash[:error] = "Wrong Username or Password."
      redirect_to rants_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to rants_path, notice: "You've logged out. (And hopefully cooled off)"
  end

  private

  def session_params
    params.require(:session).permit(:user_id)
  end

end
