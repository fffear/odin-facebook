# == Schema Information
#
# Table name: friendships
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requestee_id :integer          not null
#  requester_id :integer          not null
#
# Indexes
#
#  index_friendships_on_requestee_id_and_requester_id  (requestee_id,requester_id) UNIQUE
#  index_friendships_on_requester_id                   (requester_id)
#

FactoryBot.define do
  factory :friendship do
    association :requester, factory: :user
    association :requestee, factory: :user, first_name: "Tim", email: Faker::Internet.free_email
  end
end
