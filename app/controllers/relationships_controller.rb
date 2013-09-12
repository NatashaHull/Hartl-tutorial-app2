class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      flash.now[:success] = "You are now following #{@user.name}"
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      flash.now[:success] = "You are no longer following #{@user.name}"
      format.html { redirect_to @user }
      format.js
    end
  end
end