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

FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    association :author, factory: :user
  end
end
