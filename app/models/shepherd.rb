class Shepherd < ApplicationRecord
	has_many :animals, dependent: :destroy

	has_many :active_relationships, class_name: "Relationship",
																	foreign_key: "follower_id",
																	dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship",
																	 foreign_key: "followed_id",
																	 dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

  extend FriendlyId
	friendly_id :username

	attr_accessor :remember_token, :activation_token, :reset_token
	before_save   :downcase_email
	before_save   :downcase_username
	before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 50 }
	VALID_USERNAME_REGEX = /\A[\S]*\z/i
  validates :username, presence: true, length: { maximum: 50 },
										uniqueness: { case_sensitive: false },
										format: { with: VALID_USERNAME_REGEX,
															message: "cannot contain spaces" }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 250 },
 										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


	def Shepherd.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
 																									BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def Shepherd.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = Shepherd.new_token
		update_attribute(:remember_digest, Shepherd.digest(remember_token))
	end

	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def activate
		update_columns(activated: true, activated_at: Time.zone.now)
	end

	def send_activation_email
			ShepherdMailer.account_activation(self).deliver_now
	end

	def create_reset_digest
		self.reset_token = Shepherd.new_token
		update_columns(reset_digest: Shepherd.digest(reset_token), reset_sent_at: Time.zone.now)
	end

	def send_password_reset_email
		ShepherdMailer.password_reset(self).deliver_now
	end

	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end


	def feed
		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :shepherd_id"

		Animal.where("shepherd_id IN (#{following_ids}) OR shepherd_id = :shepherd_id", shepherd_id: id)
	end


	def follow(other_shepherd)
		active_relationships.create(followed_id: other_shepherd.id)
	end

	def unfollow(other_shepherd)
		active_relationships.find_by(followed_id: other_shepherd.id).destroy
	end

	def following?(other_user)
		following.include?(other_user)
	end

	private

		def create_activation_digest
			self.activation_token = Shepherd.new_token
			self.activation_digest = Shepherd.digest(activation_token)
		end

		def downcase_email
			email.downcase!
		end

		def downcase_username
			username.downcase!
		end

end
