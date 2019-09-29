class CommentsController < ApplicationController
  before_action :require_login

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = params[:post_id].to_i
    if @comment.save
      flash[:notice] = "Comment created."
    else
      flash[:alert] = "Comment couldn't be created."
    end
    redirect_back fallback_location: news_feed_url
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
