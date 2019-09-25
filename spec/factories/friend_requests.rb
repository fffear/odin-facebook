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

FactoryBot.define do
  factory :friend_request do
    requester_id { 1 }
    requestee_id { 2 }
  end
end
