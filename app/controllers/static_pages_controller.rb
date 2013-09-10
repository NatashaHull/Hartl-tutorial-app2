class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@user = current_user
	  	@micropost = @user.microposts.build
	  	@microposts = @user.microposts.paginate(page: params[:page])
	  	@feed_items = @user.feed.paginate(page: params[:page])
	  end
  end
  
  def help
  end
  
  def about
  end
  
  def contact
  end
end
