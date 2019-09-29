# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#
# Indexes
#
#  index_posts_on_author_id  (author_id)
#

class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper

  validates :content, presence: true, length: { maximum: 63206 }

  belongs_to :author, { class_name: :User, foreign_key: :author_id }
  has_many :likes, { dependent: :destroy }
  has_many :comments, { dependent: :destroy }

  def user_already_liked_post?(user)
    likes.where(user_id: user.id).any?
  end

  def time_of_creation_as_words
    "posted " + time_ago_in_words(created_at) + " ago"
  end
end
