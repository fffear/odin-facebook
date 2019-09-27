# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_post_id_and_user_id  (post_id,user_id) UNIQUE
#  index_likes_on_user_id              (user_id)
#

require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { FactoryBot.build(:like) }

  describe "validations" do
    it {should validate_uniqueness_of(:post_id).scoped_to(:user_id).with_message("has already been liked.") }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
    it { should have_db_index(:user_id) }
    it { should have_db_index(:post_id) }
    it { should have_db_index([:post_id, :user_id]).unique }
  end


end
