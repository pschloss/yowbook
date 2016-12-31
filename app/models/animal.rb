class Animal < ApplicationRecord
  belongs_to :shepherd
	default_scope -> { order(birth_date: :desc, eartag: :asc) }
	mount_uploader :picture, PictureUploader
	validates :shepherd_id, presence: true
	validates :eartag, presence: true, length: { maximum: 20 }
	validates_date :birth_date, presence: true, :on_or_before => lambda { Date.current }
	validate :picture_size
	before_save :refresh_shepherd


	private

		def picture_size
			if picture.size > 5.megabytes
				errors.add(:picture, "should be less than 5MB")
			end
		end

		#touch the shepherd's record to update the updated_at field
		def refresh_shepherd
		  Shepherd.find_by(id: shepherd_id).touch
		end

end
