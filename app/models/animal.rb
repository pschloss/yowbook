class Animal < ApplicationRecord
  belongs_to :shepherd
	default_scope -> { order(birth_date: :desc, eartag: :asc) }
	validates :shepherd_id, presence: true
	validates :eartag, presence: true, length: { maximum: 20 }
	validates_date :birth_date, presence: true, :on_or_before => lambda { Date.current }
end
