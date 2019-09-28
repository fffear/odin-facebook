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

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    it { should validate_length_of(:content).is_at_most(8000) }
  end

  describe "associations" do
    it { should belong_to(:author).class_name(:User) }
    it { should belong_to(:post) }
    it { should have_db_index(:author_id) }
    it { should have_db_index(:post_id) }
    it { should have_db_index([:post_id, :author_id]) }
  end
end
