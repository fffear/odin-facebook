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

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { FactoryBot.create(:post) }
  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content) }
  end

  describe "associations" do
    it { should belong_to(:author).class_name(:User) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "custom methods" do
    it "#time_of_creation_as_words" do
      expect(post.time_of_creation_as_words).to match(/^posted/)
      expect(post.time_of_creation_as_words).to match(/ago$/)
      expect(post.time_of_creation_as_words).to match(/less than a minute/)
    end
  end
end
