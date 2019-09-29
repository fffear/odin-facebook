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

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    association :author, factory: :user
    association :post, factory: :post
  end
end
