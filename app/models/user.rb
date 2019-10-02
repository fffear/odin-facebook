# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
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
         :recoverable, :rememberable, :validatable, :omniauthable, { omniauth_providers: %i[facebook] }

  validates :first_name, :last_name, presence: true,
                                     format: { with: /\A[a-zA-Z]+\z/, message: "should only allow letters" }

  has_many :friend_requests, { foreign_key: :requester_id, dependent: :destroy }
  has_many :friend_requests_received, { class_name: :FriendRequest, foreign_key: :requestee_id, dependent: :destroy }
  has_many :pending_friends, { through: :friend_requests, source: :requestee }
  has_many :pending_friends_inverse, { through: :friend_requests_received, source: :requester }

  has_many :friendships, { foreign_key: :requester_id, dependent: :destroy }
  has_many :inverse_friendships, { class_name: :Friendship, foreign_key: :requestee_id, dependent: :destroy }
  has_many :friends_as_requester, { through: :friendships, source: :requestee }
  has_many :friends_as_requestee, { through: :inverse_friendships, source: :requester }

  has_many :posts, { foreign_key: :author_id, dependent: :destroy }
  has_many :likes, { dependent: :destroy }
  has_many :comments, { foreign_key: :author_id, dependent: :destroy }
  
  before_save :capitalize_first_and_last_name
  before_save :downcase_email

  # , friend_requests.requester_id AS fr_req, friend_requests.requestee_id AS fr_ree
  scope :not_friends_with, ->(user) do
    friends_as_the_requester = "SELECT friendships.requestee_id FROM friendships
                                WHERE friendships.requester_id = :user_id"
    friends_as_the_requestee = "SELECT friendships.requester_id FROM friendships
                                WHERE friendships.requestee_id = :user_id"
    friend_requests_as_requester = "SELECT friend_requests.requestee_id FROM friend_requests
                                    WHERE friend_requests.requester_id = :user_id"
    friend_requests_as_requestee = "SELECT friend_requests.requester_id FROM friend_requests
                                     WHERE friend_requests.requestee_id = :user_id"

    select("users.*")
    .joins("LEFT OUTER JOIN friendships ON (friendships.requestee_id = users.id)")
    .joins("LEFT OUTER JOIN friend_requests ON (friend_requests.requestee_id = users.id)")
    .where("users.id != :user_id", user_id: user.id)
    .where("users.id NOT IN (#{friend_requests_as_requester}) AND
            users.id NOT IN (#{friend_requests_as_requestee}) AND
            users.id NOT IN (#{friends_as_the_requester}) AND
            users.id NOT IN (#{friends_as_the_requestee})", user_id: user.id)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.provider = auth.provider
      user.uid = auth.uid
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def full_name
    first_name + " " + last_name
  end

  def friends
    friends_as_requester + friends_as_requestee
  end

  def news_feed
    Post.where("author_id IN (?) OR author_id = ?", friends.pluck(:id), id)
        .includes(:author, :likes, comments: :author)
  end

  def specific_friendship_with(user)
    friendships.find_by(requestee: user) || inverse_friendships.find_by(requester: user)
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
