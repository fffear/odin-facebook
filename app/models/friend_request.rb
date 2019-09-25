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

class FriendRequest < ApplicationRecord
  validates :requestee_id, uniqueness: { scope: :requester_id,
                                         message: ->(object, data) do
                                          "#{object.requestee.email} has already been sent a friend request"
                                         end }
  # validates :requestee_id, presence: { message: "there needs to be something here"}

  belongs_to :requester, { class_name: :User, foreign_key: :requester_id }
  belongs_to :requestee, { class_name: :User, foreign_key: :requestee_id }

  #HUMANIZED_ATTRIBUTES = {
  #  requestee_id: ""
  #}
#
  #def self.human_attribute_name(attr, options={})
  #  HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  #end
end
