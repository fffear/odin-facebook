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
                                          "^#{object.requestee.first_name} has already been sent a friend request"
                                         end }
  validate :not_pending
  validate :not_friends
  validate :requester_is_not_requestee

  belongs_to :requester, { class_name: :User, foreign_key: :requester_id }
  belongs_to :requestee, { class_name: :User, foreign_key: :requestee_id }

  private
    def not_pending
      if self.requestee.pending_friends.include?(requester)
        errors[:base] << "#{requestee.first_name} has already sent you a friend request."
      end
    end

    def not_friends
      if self.requestee.friends.include?(requester)
        errors[:base] << "You are already friends with #{requestee.first_name}."
      end
    end

    def requester_is_not_requestee
      if requester == requestee
        errors[:base] << "You can't request to be friends with yourself."
      end
    end
end
