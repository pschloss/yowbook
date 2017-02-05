class Weight < ApplicationRecord
  belongs_to :animal
  validates :animal_id, presence: true
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1000 }
  validates :weight_type, presence: true,
									inclusion: { in: %w(birth weaning early_post_weaning post_weaning yearling hogget
 																			adult maintenance hanging),
															message: "%{value} is not an accepted value." }
  validates_date :date, presence: true,
									on_or_before: lambda { Date.current },
									on_or_before_message: "must be today or earlier",
									format: 'yyyy-mm-dd',
									invalid_date_message: "must be in YYYY-MM-DD format"
	validate :weight_type_age
	validate :weight_type_existance
  default_scope { order(:date) }

	private

		def weight_type_age

			if(!animal.nil? && !date.nil? )
				case weight_type
				when "birth"

					if date != animal.birth_date
						errors.add(:date, "should be the same as the lamb's birth date")
					end

				when "weaning"

					if (date - animal.birth_date).to_i < 40 || (date - animal.birth_date).to_i > 120
						errors.add(weight_type,
									"weight should be taken between 40 and 120 days after the lamb's birth date")
					end

				when "early_post_weaning"
					if date - animal.birth_date < 80 || date - animal.birth_date > 240
						errors.add(weight_type,
										"weight should be taken between 80 and 240 days after the lamb's birth date")
					end

				when "post_weaning"

					if date - animal.birth_date < 160 || date - animal.birth_date > 340
						errors.add(weight_type,
									"weight should be taken between 160 and 340 days after the lamb's birth date")
					end

				when "yearling"

					if date - animal.birth_date < 290 || date - animal.birth_date > 430
						errors.add(weight_type,
									"weight should be taken between 290 and 430 days after the lamb's birth date")
					end

				when "hogget"

					if date - animal.birth_date < 410 || date - animal.birth_date > 550
						errors.add(weight_type,
									"weight should be taken between 410 and 550 days after the lamb's birth date")
					end

				when "adult"

					if date - animal.birth_date < 530 || date - animal.birth_date > 2315
						errors.add(weight_type,
									"weight should be taken between 530 and 2315 days after the lamb's birth date")
					end

				when "hanging"

					if date < animal.birth_date
						errors.add(:date, "should be after the lamb's birth date")
					end

				when "maintenance"
					errors.add(:date,
									"should be after the lamb's birth date") if
						date < animal.birth_date
				end
			else
				errors.add(:date, "must exist.")
			end
		end


		def weight_type_existance

			if !animal.nil? && animal.weights.length != 0
				other_weight_type = animal.weights.find_by(weight_type: weight_type)
				errors.add(weight_type, "record already exists for this animal.") unless
					weight_type == "maintenance" || other_weight_type.nil? || other_weight_type.id == id
			end

		end

end
