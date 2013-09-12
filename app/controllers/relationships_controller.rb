class RelationshipsController < ApplicationController
  before_action :signed_in_user
  respond_to :html, :js

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    flash.now[:success] = "You are now following #{@user.name}"
    respond_with(@user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    flash.now[:success] = "You are no longer following #{@user.name}"
    respond_with(@user)
  end
end