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

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  subject(:friendship) { FactoryBot.build(:friendship) }
  
  describe 'validations' do
  end

  describe 'associations' do
    it { should belong_to(:requester).class_name(:User) }
    it { should belong_to(:requestee).class_name(:User) }
    it { should have_db_index([:requestee_id, :requester_id]).unique }
    it { should have_db_index(:requester_id) }
    it do 
      should validate_uniqueness_of(:requestee_id)
        .scoped_to(:requester_id)
        .with_message("^#{friendship.requestee.first_name} is already a friend")
    end
  end

  describe 'custom methods' do
    context "#requester_is_not_requestee" do
      it "fails validation when requester and requestee are the same with a specific message" do
        friendship.requestee = friendship.requester
        friendship.valid?
        expect(friendship.errors[:base][0]).to include("You can't be friends with yourself.")
      end
    end

    context "#return_inverse_role" do
      it "returns the reciprical role of the user passed in as the argument" do
        requestee = friendship.requestee
        requester = friendship.requester
        expect(friendship.return_inverse_role(requester)).to eq(requestee)
      end
    end
  end
end
