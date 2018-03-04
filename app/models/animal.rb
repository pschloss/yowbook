class Animal < ApplicationRecord
	attr_accessor :dam_eartag
	attr_accessor :sire_eartag

	has_many :weights
  belongs_to :shepherd

	belongs_to :dam, class_name: 'Animal'
	belongs_to :sire, class_name: 'Animal'

  has_many :children_as_sire, class_name: 'Animal', foreign_key: :sire_id
  has_many :children_as_dam, class_name: 'Animal', foreign_key: :dam_id

  after_initialize :set_defaults, unless: :persisted?

	default_scope -> { order(birth_date: :desc, eartag: :desc) }
	mount_uploader :picture, PictureUploader

	validates :shepherd_id, presence: true
	validates :eartag, presence: true,
											length: { maximum: 20 },
											uniqueness: { scope: :shepherd_id,
											message: "That eartag is already taken" }
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


	validate :dam_eartag_valid
	validate :sire_eartag_valid

	validate :dam_sire_name
	validate :dam_sex
	validate :sire_sex

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

  def children
	  case sex
	  when 'ram'
	    children_as_sire
	  when 'ewe'
	    children_as_dam
		else
			nil
	  end
  end

	def pedigree
		pedigree_hash = Hash.new
		pedigree_hash.default = "Unknown"
		pedigree_hash[:self] = eartag

		#maternal second generation
		if(dam.present?)
			pedigree_hash[:dam] = dam.eartag

			#maternal third generation
			if(dam.dam.present?)
				pedigree_hash[:dam_dam] = dam.dam.eartag

				#maternal fourth generation
				if(dam.dam.dam.present?)
					pedigree_hash[:dam_dam_dam] = dam.dam.dam.eartag
				end
				if(dam.dam.sire.present?)
					pedigree_hash[:dam_dam_sire] = dam.dam.sire.eartag
				end
			end

			if(dam.sire.present?)
				pedigree_hash[:dam_sire] = dam.sire.eartag

				if(dam.sire.dam.present?)
					pedigree_hash[:dam_sire_dam] = dam.sire.dam.eartag
				end
				if(dam.sire.sire.present?)
					pedigree_hash[:dam_sire_sire] = dam.sire.sire.eartag
				end
			end
		end

		#paternal second generation
		if(sire.present?)
			pedigree_hash[:sire] = sire.eartag

			#paternal third generation
			if(sire.dam.present?)
				pedigree_hash[:sire_dam] = sire.dam.eartag

				#paternal fourth generation
				if(sire.dam.dam.present?)
					pedigree_hash[:sire_dam_dam] = sire.dam.dam.eartag
				end
				if(sire.dam.sire.present?)
					pedigree_hash[:sire_dam_sire] = sire.dam.sire.eartag
				end

			end

			if(sire.sire.present?)
				pedigree_hash[:sire_sire] = sire.sire.eartag

				if(sire.sire.dam.present?)
					pedigree_hash[:sire_sire_dam] = sire.sire.dam.eartag
				end
				if(sire.sire.sire.present?)
					pedigree_hash[:sire_sire_sire] = sire.sire.sire.eartag
				end
			end
		end

		return pedigree_hash
	end

	def siblings
		shepherd.animals.where(dam: dam, birth_date: birth_date).where("id != ?", id)
	end

	def birth_type
		litter_name(siblings.length + 1)
	end

	def n_progeny
		children == nil ?	0 : children.count
	end

	def n_weaned
		count = 0

		if children.present?
			children.each do |c|

				old_enough = (Date.current-c.birth_date).to_i > 40
				old_active = (c.status_date - c.birth_date).to_i > 40

				if old_enough and old_active and !c.orphan
					count += 1
				end

			end
		end

		count
	end

	def n_lambings
		children.present? ? children.pluck(:birth_date).uniq.length : 0
	end

	def raised_as
		if orphan
			"Orphan"
		elsif status == 'stillborn'
			"Stillborn"
		elsif status == 'died' and (status_date - birth_date).to_i < 40
			"Dead"
		else
			count = 1

			siblings.each do |s|
				if !(s.status == 'died' and (s.status_date - s.birth_date).to_i < 40) and !s.orphan
					count += 1
				end
			end

			litter_name(count)
		end

	end


	private

		def set_defaults
			self.sire_id ||= ""
			self.dam_id ||= ""
			self.sex ||= "unknown"
			self.status ||= "active"
			self.status_date ||= Date.today

			if(shepherd.animals.present?)
				next_eartag = shepherd.animals.last.eartag.to_i + 1
				while(shepherd.animals.find_by(eartag: next_eartag).present?) do
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
				dam_eartag.present? == eartag

			errors.add(:sire, "should not have the same eartag as lamb") if
				sire_eartag.present? == eartag

			errors.add(:base, "Dam and sire should not have the same eartag") if
				sire_eartag.present? && dam_eartag.present? && sire_eartag == dam_eartag
		end


		def dam_eartag_valid

			if dam_eartag.present?
				dam = shepherd.animals.find_by(eartag: dam_eartag)

	    	if dam.nil?
	      	self.errors.add(:dam_eartag, "does not exist in database. Add her before this animal")
	    	elsif dam.present?
	      	self.dam = dam
	    	end
			end

		end


		def sire_eartag_valid

	    if sire_eartag.present?
				sire = shepherd.animals.find_by(eartag: sire_eartag)

				if sire.nil?
	      	self.errors.add(:sire_eartag, "does not exist in database. Add him before this animal")
	    	elsif sire.present?
	      	self.sire = sire
	    	end
			end

		end


		def dam_sex
			errors.add(:dam, "should be a ewe, not a #{dam.sex}") if
				dam.present? && dam.sex != 'ewe'
		end


		def sire_sex
			errors.add(:sire, "should be a ram, not a #{sire.sex}") if
				sire.present? && sire.sex != 'ram'
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


		def litter_name(number)
			hash = { 0=> "Orphan", 1=> "Single", 2=> "Twin", 3=> "Triplet", 4=> "Quadruplet",
								5=> "Quintuplet", 6=> "Sextuplet", 7=> "Septuplet", 8=> "Octuplet", 9=> "Nonuplet"}

			hash[number]
		end


		#touch the shepherd's record to update the updated_at field
		def refresh_shepherd
		  shepherd.touch
		end

end
