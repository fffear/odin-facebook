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
  describe 'validations' do
    it { should validate_presence_of(:requester).with_message("must exist") }
    it { should validate_presence_of(:requestee).with_message("must exist") }
    
  end

  describe 'associations' do
    it { should belong_to(:requester).class_name(:User) }
    it { should belong_to(:requestee).class_name(:User) }
    it { should have_db_index(:requester_id) }
    it { should have_db_index(:requestee_id) }
    it { should have_db_index([:requestee_id, :requester_id]).unique }
  end
#
  #describe 'scopes' do
  #end
#
  #describe 'custom methods' do
  #end
end
