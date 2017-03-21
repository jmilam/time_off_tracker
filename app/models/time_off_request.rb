class TimeOffRequest < ApplicationRecord
	validates :manager_id, :time_off_type, :date_start, :date_end, presence: true
	belongs_to :user, dependent: :destroy
	belongs_to :manager

	scope :not_approved, -> {where(approved: false)}
	scope :pending, -> {where(approved: nil)}
	scope :approved, -> {where(approved: true)}
	scope :vacation, -> {where(time_off_type: "Vacation", cancelled: false)}
	scope :personal, -> {where(time_off_type: "Personal", cancelled: false)}

	def status
		case self.approved
		when true
			canceled? ? "Cancelled" : "Approved"
		when false
			canceled? ? "Canceled" : "Not Approved"
		when nil
			cancelled? ? "Canceled" : "Pending"
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

	def canceled?
		self.cancelled
	end
end
