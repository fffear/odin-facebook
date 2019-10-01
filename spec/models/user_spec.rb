# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should_not allow_value('1User', 'T_Kennedy').for(:first_name).with_message("should only allow letters") }
    it { should_not allow_value('1User', 'T_Kennedy').for(:last_name).with_message("should only allow letters") }

  end

  describe 'associations' do
    it { should have_many(:friend_requests).dependent(:destroy) }
    it { should have_many(:friend_requests_received).class_name(:FriendRequest).dependent(:destroy) }
    it { should have_many(:pending_friends).through(:friend_requests).source(:requestee) }
    it { should have_many(:pending_friends_inverse).through(:friend_requests_received).source(:requester) }
    it { should have_many(:friendships).dependent(:destroy) }
    it { should have_many(:inverse_friendships).class_name(:Friendship).dependent(:destroy) }
    it { should have_many(:friends_as_requester).through(:friendships).source(:requestee) }
    it { should have_many(:friends_as_requestee).through(:inverse_friendships).source(:requester) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'should capitalize first and last name before save' do
      user.first_name = "test"
      user.last_name = "user"
      capitalized_first_name = user.first_name.capitalize
      capitalized_last_name = user.last_name.capitalize
      user.save
      expect(user.first_name).to eq(capitalized_first_name)
      expect(user.last_name).to eq(capitalized_last_name)
    end

    it 'should downcase email before save' do
      user.email = "TEStemail@example.com"
      lowercase_email = user.email.downcase
      user.save
      expect(user.email).to eq(lowercase_email)
    end
  end

  describe 'scopes' do
    RSpec::Matchers.define_negated_matcher :be_collection_excluding, :include
    let(:friendship) { FactoryBot.create(:friendship) }

    context '::not_friends_with' do
      it 'should return all users who are not friends or who are not pending' do
        user_1 = friendship.requester
        user_2 = friendship.requestee
        user_3 = FactoryBot.create(:user, first_name: "Testone", last_name: "Userone")
        user_4 = FactoryBot.create(:user)
        user_5 = FactoryBot.create(:user)
        user_6 = FactoryBot.create(:user)
        FactoryBot.create(:friendship, requester: user_6, requestee: user_1)
        FactoryBot.create(:friend_request, requester: user_4, requestee: user_1)
        FactoryBot.create(:friend_request, requester: user_1, requestee: user_5)
        expect(User.not_friends_with(user_1)).to be_collection_excluding(user_4)
        expect(User.not_friends_with(user_1)).to be_collection_excluding(user_5)
        expect(User.not_friends_with(user_1)).to be_collection_excluding(user_6)
        expect(User.not_friends_with(user_1)).to include(user_3)
      end
    end
  end

  describe 'custom methods' do
    let(:friendship) { FactoryBot.create(:friendship) }

    context '#full_name' do
      it 'should return string with first and last name concatenated' do
        user.save
        expect(user.full_name).to eq("Test User")
      end
    end

    context '#specific_friendship_with' do
      it 'should return a friendship object and with the user argument as either the requester or requestee' do
        user_1 = friendship.requester
        user_2 = friendship.requestee
        friendship_1 = user_1.specific_friendship_with(user_2)
        expect(friendship_1).to eq(friendship)
      end
    end

    context '#friends' do
      it 'should return a friends as either the requester or requestee' do
        user_1 = friendship.requester
        user_2 = friendship.requestee
        expect(user_1.friends).to include(user_2)
        expect(user_2.friends).to include(user_1)
      end
    end

    context '#news_feed' do
      it 'should return the posts of yourself and all your friends' do
        user_1 = friendship.requester
        user_2 = friendship.requestee
        user_1.posts << FactoryBot.create(:post, author: user_1)
        user_2.posts << FactoryBot.create(:post, author: user_2)
        user.save
        user.posts << FactoryBot.create(:post, author: user)
        expect(user_1.news_feed.count).to eq(2)
        expect(user_1.news_feed).to include(user_1.posts[0], user_2.posts[0])
        expect(user_1.news_feed).to_not include(user.posts[0])
      end

      it "should eager load author, comments and likes" do
        user_1 = friendship.requester
        user_2 = friendship.requestee
        user_1.posts << FactoryBot.create(:post, author: user_1)
        user_1.posts[0].comments << FactoryBot.create(:comment, author: user_2, post: user_1.posts[0])
        expect(user_1.news_feed[0].association(:author).loaded?).to be(true)
        expect(user_1.news_feed[0].association(:likes).loaded?).to be(true)
        expect(user_1.news_feed[0].association(:comments).loaded?).to be(true)
        expect(user_1.news_feed[0].comments[0].association(:author).loaded?).to be(true)
      end
    end
  end
end
