class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(post_id: params[:post_id])
    if @like.save
      flash[:notice] = "Post liked."
    else
      flash[:alert] = "Unable to like post"
    end

    redirect_back fallback_location: user_url(Post.find(params[:post_id]).author)
  end


end
