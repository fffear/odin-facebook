class FriendshipsController < ApplicationController
  def create
    requester = User.find(params[:requester_id])
    @friendship = requester.friendships.build(requestee: current_user)

    if @friendship.save
      flash[:notice] = "Accepted friend request."
      @friend_request = FriendRequest.find_by(requestee_id: current_user.id, requester_id: params[:requester_id])
      @friend_request.delete
    else
      flash[:alert] = @friendship.errors.full_messages.first
    end

    redirect_back(fallback_location: user_path(current_user))
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    @unfriended_user = @friendship.return_inverse_role(current_user)
    flash[:notice] = "#{@unfriended_user.first_name} unfriended."
    redirect_back(fallback_location: user_path(current_user))
  end
end
