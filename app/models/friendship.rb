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

class Friendship < ApplicationRecord
  validates :requestee_id, uniqueness: { scope: :requester_id,
                                         message: ->(object, data) do
                                          "^#{object.requestee.first_name} is already a friend"
                                         end }

  validate :requester_is_not_requestee

  belongs_to :requester, { class_name: :User, foreign_key: :requester_id }
  belongs_to :requestee, { class_name: :User, foreign_key: :requestee_id }

  def return_inverse_role(user)
    if user == requester
      requestee
    elsif user == requestee
      requester
    end
  end
  private
    def requester_is_not_requestee
      if requester == requestee
        errors[:base] << "You can't be friends with yourself."
      end
    end
end
