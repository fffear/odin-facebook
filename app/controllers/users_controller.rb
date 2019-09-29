class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post = current_user.posts.build if user_signed_in?

  end

  def edit
  end

  def update
  end

  private
  #  def user_params
  #    params.require(:user).permit(:)
  #  end
end
