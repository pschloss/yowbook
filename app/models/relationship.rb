class Relationship < ApplicationRecord
	belongs_to :follower, class_name: "Shepherd"
	belongs_to :followed, class_name: "Shepherd"

	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
