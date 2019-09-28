# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_author_id              (author_id)
#  index_comments_on_post_id                (post_id)
#  index_comments_on_post_id_and_author_id  (post_id,author_id)
#

class Comment < ApplicationRecord
  validates :content, presence: true, length: { maximum: 8000 }

  belongs_to :author, { class_name: :User, foreign_key: :author_id }
  belongs_to :post
end
