require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:friend_request) { FactoryBot.create(:friend_request) }
  let(:friendship) { FactoryBot.create(:friendship, requester: friend_request.requester,
                                                    requestee: friend_request.requestee) }

  describe "POST #create" do
    it "assert flash notice and redirect_to user_path" do
      sign_in(friend_request.requestee)
      post :create, params: { requester_id: friend_request.requester_id }
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to(friend_request.requestee)
    end
  end

  describe "DELETE #destroy" do
    it "assert flash notice and redirect_to user_path" do
      sign_in(friendship.requestee)
      delete :destroy, params: { id: friendship.id }
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to(friend_request.requestee)
    end
  end
end
