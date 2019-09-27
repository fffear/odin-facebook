# == Schema Information
#
# Table name: friend_requests
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requestee_id :bigint
#  requester_id :bigint
#
# Indexes
#
#  index_friend_requests_on_requestee_id                   (requestee_id)
#  index_friend_requests_on_requestee_id_and_requester_id  (requestee_id,requester_id) UNIQUE
#  index_friend_requests_on_requester_id                   (requester_id)
#

require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  subject(:friend_request) { 
    FactoryBot.build(:friend_request)
  }

  describe 'validations' do
    it { should validate_presence_of(:requester).with_message("must exist") }
  end

  describe 'associations' do
    it { should belong_to(:requester).class_name(:User) }
    it { should have_db_index(:requester_id) }
    it { should have_db_index(:requestee_id) }
    it { should have_db_index([:requestee_id, :requester_id]).unique }

    it "should belong to requestee class_name => User required: true" do 
      expect(friend_request.requestee.new_record?).to be(false)
      expect(friend_request.requestee.class).to be(User)
    end

    it do 
      should validate_uniqueness_of(:requestee_id)
        .scoped_to(:requester_id)
        .with_message("^#{friend_request.requestee.first_name} has already been sent a friend request")
    end
  end

  describe 'custom methods' do
    context '#not_pending' do
      it 'fails validation when a friend request with the same requester and requestee already exists with a specific message' do
        friend_request.save
        friend_request_2 = FactoryBot.build(:friend_request, requester_id: friend_request.requestee_id,
                                                             requestee_id: friend_request.requester_id)
        friend_request_2.valid?
        expect(friend_request_2.errors[:base][0]).to include('has already sent you a friend request.')
      end
    end

    context '#not_friends' do
      it 'fails validation when requester and requestee are already friends with a specific message' do
        FactoryBot.create(:friendship, requester: friend_request.requester,
                                      requestee: friend_request.requestee)
        friend_request.valid?
        expect(friend_request.errors[:base][0]).to include('You are already friends with')
      end
    end

    context '#requester_is_not_requestee' do
      it 'fails validation when requester and requestee are the same with a specific message' do
        friend_request.requestee = friend_request.requester
        friend_request.valid?
        expect(friend_request.errors[:base][0]).to include('You can\'t request to be friends with yourself.')
      end
    end
  end
end
