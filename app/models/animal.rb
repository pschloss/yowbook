class Animal < ApplicationRecord
	has_many :weights
  belongs_to :shepherd

  after_initialize :set_defaults, unless: :persisted?
	default_scope -> { order(birth_date: :desc, eartag: :desc) }
	mount_uploader :picture, PictureUploader
	validates :shepherd_id, presence: true
	validates :eartag, presence: true,
											length: { maximum: 20 },
											uniqueness: { scope: :shepherd_id,
																		message: "That eartag is already taken" }
	validates :dam, length: { maximum: 20 }
	validates :sire, length: { maximum: 20 }
	validates :sex, length: { maximum: 10 },
									inclusion: { in: %w(ewe ram wether teaser unknown),
															message: "%{value} is not an accepted value." }
	validates :status, length: { maximum: 10 },
									inclusion: { in: %w(active stillborn died sold culled),
															message: "%{value} is not an accepted value." }
	validates_date :status_date, presence: true,
															on_or_before: lambda { Date.current },
															on_or_before_message: "must be today or earlier",
															format: 'yyyy-mm-dd',
															invalid_date_message: "must be in YYYY-MM-DD format"
	validates_date :birth_date, presence: true,
															on_or_before: lambda { Date.current },
															on_or_before_message: "must be today or earlier",
															format: 'yyyy-mm-dd',
															invalid_date_message: "must be in YYYY-MM-DD format"
	validate :dam_sire_name
	validate :picture_size
	validate :status_and_date
	before_save :refresh_shepherd

	def last_weight

		if weights.count==0 || weights.first.nil?
			"NA"
		else
			# i think because this method is used on the animal show page where a weight is built, it
 			# shows up as a nil-valued weight at the end of the array. so we need to remove the last
			# weight value if it is nil.
			w = weights.reject { |w| w.id.nil? || w.id == ''}
			w.last.weight
		end
	end




	private
		def activate_animal
		end

		def set_defaults
			self.sire ||= ""
			self.dam ||= ""
			self.sex ||= "unknown"
			self.status ||= "active"
			self.status_date ||= Date.today

			if(!Animal.find_by(shepherd_id: shepherd.id).nil?)
				next_eartag = Animal.find_by(shepherd_id: shepherd.id).eartag.to_i + 1
				while(!Animal.find_by(shepherd_id: shepherd.id, eartag: next_eartag).nil?) do
					next_eartag = next_eartag + 1
				end
			else
				next_eartag = 1
			end

			self.eartag ||= next_eartag
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

		def status_and_date
			if(!status_date.nil? && !status.nil?)

				if(status == "stillborn")

					errors.add(:date, "should be the same as the lamb's birth date") if status_date != birth_date

				elsif (status == "died" || status == "sold" || status == "culled")

					errors.add(:date, "should be after the lamb's birth date") if status_date <= birth_date

				end

			else
				errors.add(:date_and_status, "must exist.")
			end
		end


		#touch the shepherd's record to update the updated_at field
		def refresh_shepherd
		  shepherd.touch
		end



end
