class FriendRequestsController < ApplicationController
  def create
    requestee = User.find(params[:requestee_id])
    @friend_request = current_user.friend_requests.build(requestee: requestee)

    if @friend_request.save
      flash[:notice] = "Friend request has been sent to #{requestee.first_name}"
    else
      flash[:alert] = @friend_request.errors.full_messages.first
    end

    redirect_back(fallback_location: user_path(requestee))
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
    flash[:notice] = "Friend request cancelled."
    redirect_back(fallback_location: user_path(@friend_request.requestee))
  end

  private
    def friend_request_params
      params.require(:friend_request).permit(:requester_id, :requestee_id)
    end
end
