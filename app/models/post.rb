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
  validates :content, length: { maximum: 63206 }

  belongs_to :author, { class_name: :User, foreign_key: :author_id }
  has_many :likes, { dependent: :destroy }
end
