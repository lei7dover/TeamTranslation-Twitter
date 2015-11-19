class UsersController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action :require_no_user, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    @user=current_user
    @users = User.all
    @rants = Rant.all.order("created_at DESC").page(params[:page] || 1).per(10)
    @rant = Rant.new
    @relationship = Relationship.where(follower_id: current_user.id,
    followed_id: @user.id).first_or_initialize if current_user
  end

  def new
    if current_user
      redirect_to user_path
    else
      @user =User.new
    end
  end

  def update
    @rant = Rant.new
    @rant.save
    redirect_to users_path, method: :post
  end


  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thank you for signing up!"
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated!'
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    @users= User.all
    @rant = Rant.new
    @rants = @user.rants.order("created_at DESC").page(params[:page] || 1).per(10)
    @relationship = Relationship.where(follower_id: current_user.id,
    followed_id: @user.id).first_or_initialize if current_user
  end

  def destroy
    @user.destroy
      redirect_to root_path
  end

  def friends
    @user = current_user
    @rant= Rant.new
    @rants = Rant.all.order("created_at DESC").page(params[:page] || 1).per(10)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:username, :email, :password, :name, :password_confirmation, :content)
  end

end
