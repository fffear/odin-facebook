require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  let(:friend_request) { FactoryBot.create(:friend_request) }
  let(:friendship) { FactoryBot.create(:friendship, requester: friend_request.requester,
                                                    requestee: friend_request.requestee) }

  describe 'POST #create' do
    # friend request alread exists
    describe 'failing validations' do
      it 'requester already sent friend request to requestee' do
        sign_in(friend_request.requester)
        post :create, params: { requestee_id: friend_request.requestee_id }
        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(friend_request.requestee)
      end

      it 'requestee already sent friend request to requester' do
        sign_in(friend_request.requestee)
        post :create, params: { requestee_id: friend_request.requester_id }
        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(friend_request.requester)
      end

      it 'already friends' do
        sign_in(friendship.requester)
        post :create, params: { requestee_id: friendship.requestee_id }
        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(friendship.requestee)
      end

      it 'send friend request to yourself' do
        sign_in(friendship.requester)
        post :create, params: { requestee_id: friendship.requester_id }
        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(friendship.requester)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'cancels friend request' do
      sign_in(friend_request.requester)
      delete :destroy, params: { id: friend_request.id }
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to(friendship.requestee)
    end
  end
end
