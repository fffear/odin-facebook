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
    it { should have_many(:friend_requests) }
    it { should have_many(:friend_requests_received).class_name(:FriendRequest) }
    it { should have_many(:pending_friends).through(:friend_requests).source(:requestee) }
    it { should have_many(:pending_friends_inverse).through(:friend_requests_received).source(:requester) }
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

  describe 'custom methods' do
    context '#full_name' do
      it 'should return string with first and last name concatenated' do
        user.save
        expect(user.full_name).to eq("Test User")
      end
    end
  end
end
