class TimeOffRequest < ApplicationRecord
	validates :manager_id, :time_off_type, :date_start, :date_end, presence: true
	belongs_to :user
	belongs_to :manager

	scope :not_approved, -> {where(approved: false)}
	scope :pending, -> {where(approved: nil)}

	def status
		case self.approved
		when true
			"Approved"
		when false
			"Not Approved"
		when nil
			"Pending"
		end
	end
end
