class TimeOffRequest < ApplicationRecord
	validates :manager_id, :time_off_type, :date_start, :date_end, presence: true
	belongs_to :user, dependent: :destroy
	belongs_to :manager

	scope :not_approved, -> {where(approved: false)}
	scope :pending, -> {where(approved: nil)}
	scope :vacation, -> {where(time_off_type: "Vacation")}
	scope :personal, -> {where(time_off_type: "Personal")}

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

	def days_to_hours
		if self.approved == false
			0
		else
			if hours.nil?
				((((self.date_end.end_of_day.to_time - self.date_start.to_time) /3600) / 24) * 8).round
			else
				self.hours
			end
		end
	end
end
