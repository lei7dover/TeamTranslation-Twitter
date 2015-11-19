class RelationshipsController < ApplicationController
  def create
       @relationship = Relationship.new
       @relationship.followed_id = params[:followed_id]
       @relationship.follower_id = current_user.id

   if @relationship.save
       respond_to do |format|
         format.html{redirect_to User.find params[:followed_id]}
         format.js{@user = User.find(params[:followed_id])
           render :template  => 'relationships/relationships'
         }
       end
   else
       flash[:error] = "Couldn't Follow"
       redirect_to root_url
   end
 end

 def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    respond_to do |format|
      format.html {redirect_to user_path params[:id]}
      format.js {
        @user = User.find(@relationship.followed_id)
        render :template => 'relationships/relationships'
      }
    end
  end

end
