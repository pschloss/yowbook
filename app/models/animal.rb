class Animal < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new

  belongs_to :shepherd
	default_scope -> { order(birth_date: :desc, eartag: :asc) }
	mount_uploader :picture, PictureUploader
	validates :shepherd_id, presence: true
	validates :eartag, presence: true, length: { maximum: 20 }
	validates :dam, length: { maximum: 20 }#, exclusion: { in: %w(:eartag),
						#message: "%{value} is the same as the animal." }
	validates :sire, length: { maximum: 20 }#, exclusion: { in: %w(:eartag),
						#message: "%{value} is the same as the animal." }
	validates_date :birth_date, presence: true, :on_or_before => lambda { Date.current }
	validate :dam_sire_name
	validate :picture_size
	before_save :refresh_shepherd


	private

		def set_defaults
			self.sire ||= ""
			self.dam ||= ""
		end

		def picture_size
			if picture.size > 5.megabytes
				errors.add(:picture, "should be less than 5MB")
			end
		end

		def dam_sire_name
			errors.add(:dam, "should not have the same eartag as lamb") if
				dam == eartag && dam != ""

			errors.add(:sire, "should not have the same eartag as lamb") if
				sire == eartag && sire != ""

			errors.add(:base, "Dam and sire should not have the same eartag") if
				sire == dam && sire != ""
		end


		#touch the shepherd's record to update the updated_at field
		def refresh_shepherd
		  Shepherd.find_by(id: shepherd_id).touch
		end



end
