class RantsController < ApplicationController
  before_action :set_rant, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:new,:create, :update, :destroy]

  def index
    if current_user
    @rants = Rant.timeline(current_user).order("created_at DESC").page(params[:page] || 1).per(10)
    else
    @rants= Rant.all.order("created_at DESC").page(params[:page] || 1).per(10)
    end
    @rant = Rant.new
    @users=User.all
  end

  def show
    @rant.content
  end

  def new
    @rant=Rant.new
  end

  def create
    @rant = Rant.new(rant_params)
    @rant.user= current_user
    if @rant.save
      respond_to do |format|
        format.html {redirect_to users_path}
        format.js { render :template => 'rants/create'}
      end
    else
      flash[:alert]= "There has been a problem saving your rant! Sorry."
      render :new
    end
  end

  def update
    if @rant.update(rant_params)
      redirect_to users_path, [:alert] => 'Rant was successfully update.'
    else
      render :edit
    end
  end

  def destroy
    @rant.destroy
      redirect_to rants_path [:alert] => 'Rant was successfully deleted.'
  end

  private

  def set_rant
    @rant = Rant.find(params[:id])
    unless @rant.user == @current_user
      flash[:alert]= "You are not the creator of this rant!"
      redirect_to root_url
    end
  end

  def rant_params
    params.require(:rant).permit(:content, :user_id)
  end

end
