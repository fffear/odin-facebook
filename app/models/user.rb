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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true,
                                     format: { with: /\A[a-zA-Z]+\z/, message: "should only allow letters" }

  has_many :friend_requests, { foreign_key: :requester_id, dependent: :destroy }
  has_many :friend_requests_received, { class_name: :FriendRequest, foreign_key: :requestee_id }
  has_many :pending_friends, { through: :friend_requests, source: :requestee }
  has_many :pending_friends_inverse, { through: :friend_requests_received, source: :requester }
  
  before_save :capitalize_first_and_last_name
  before_save :downcase_email

  def full_name
    first_name + " " + last_name
  end

  # Users can send Friend Requests to other Users.
  private
    def capitalize_first_and_last_name
      first_name.capitalize!
      last_name.capitalize!
    end

    def downcase_email
      email.downcase!
    end
end