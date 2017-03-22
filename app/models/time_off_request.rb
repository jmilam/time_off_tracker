class TimeOffRequest < ApplicationRecord
	require 'csv'
	validates :manager_id, :time_off_type, :date_start, :date_end, presence: true
	belongs_to :user, dependent: :destroy
	belongs_to :manager

	scope :not_approved, -> {where(approved: false)}
	scope :pending, -> {where(approved: nil)}
	scope :approved, -> {where(approved: true)}
	scope :approved_taken, -> {where('approved = ? AND date_start < ?', true, Date.today)}
	scope :approved_not_taken, -> {where('approved = ? AND date_start > ?', true, Date.today)}
	scope :vacation, -> {where(time_off_type: "Vacation", cancelled: false)}
	scope :personal, -> {where(time_off_type: "Personal", cancelled: false)}
	scope :approved_report, -> (start_date, end_date) {where('date_start >= ? AND date_end <= ? AND approved = ?', start_date, end_date, true)}

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

	def self.to_csv(data)
		csv_data = CSV.generate do |csv|
			csv << ["Employee", "Type", "Start Date", "End Date", "Approved By", "Hours"]
		  data.each do |request|
		    csv << ["#{request.user.first_name} #{request.user.last_name}", request.time_off_type, request.date_start.strftime("%m/%d/%Y"), request.date_end.strftime("%m/%d/%Y"), request.approved_by, request.hours.nil? ? 0 : request.hours]
		  end
		end
	end
end
