class Shepherd < ApplicationRecord
	has_many :animals, dependent: :destroy

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
		Animal.where("shepherd_id = ?", id)
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
