class User < ActiveRecord::Base
	before_save { email.downcase! }
	before_create :create_remember_token

	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", dependent:   :destroy
  has_many :followers, through: :reverse_relationships

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }
	
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end
	
	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
    Micropost.from_users_followed_by(self)
	end

  def following?(other_user)
  	self.relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
  	self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
  	self.relationships.find_by(followed_id: other_user.id).destroy! if following?(other_user)
  end
	private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end