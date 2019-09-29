class PostsController < ApplicationController
  before_action :require_login
  before_action :require_poster_to_be_current_user, only: :create

  def index
    @post = current_user.posts.build
    @comment = current_user.comments.build
    @news_feed = current_user.news_feed
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "Post created."
    else
      flash[:notice] = "Post can't be empty."
    end

    redirect_back fallback_location: news_feed_url
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end
end
