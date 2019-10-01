class UsersController < ApplicationController
  def index
    # are not already friends or who don’t already have a pending request
    @users = User.not_friends_with(current_user)
  end

  def show
    @user = User.includes(posts: [{ comments: :author }, :author, :likes]).find(params[:id])
    @posts = @user.posts

    if user_signed_in?
      @post = current_user.posts.build
      @comment = current_user.comments.build
    end
  end

  #def edit
  #end
#
  #def update
  #end

  private
end
