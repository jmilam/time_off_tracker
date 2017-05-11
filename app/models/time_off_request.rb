class TimeOffRequest < ApplicationRecord
	require 'csv'
	validates :manager_id, :time_off_type, :date_start, :date_end, presence: true
	belongs_to :user, dependent: :destroy
	belongs_to :manager
	has_many :status_changes

	scope :not_approved, -> {where(approved: false)}
	scope :pending, -> {where(approved: nil, cancelled: false)}
	scope :approved, -> {where(approved: true)}
	scope :vacation, -> {where(time_off_type: "Vacation", cancelled: false)}
	scope :personal, -> {where(time_off_type: "Personal", cancelled: false)}
	scope :approved_report, -> (start_date, end_date) {where('date_start >= ? AND date_end <= ? AND approved = ?', start_date, end_date, true)}
	scope :upcoming_week, -> {where('date_start >= ? AND date_end <= ? AND approved = ?', Date.today.next_week.beginning_of_week, Date.today.next_week.end_of_week, true)}

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
				holidays = Holiday.all
				date_count = (((((self.date_end - self.date_start))/3600)/24)*8).round
				 time_off_total = 0
				 0.upto(date_count/8) do |num|
				 	if num == 0
				 		time_off_total += 1 unless weekend?(self.date_start) || holiday?(self.date_start, holidays)
				 	else
				 		time_off_total += 1 unless weekend?(self.date_start + num.day) || holiday?(self.date_start + num.day, holidays)
				 	end
				 end
				time_off_total * 8
			else
				self.hours
			end
		end
	end

	def canceled?
		self.cancelled
	end

	def deduct_time_from_totals(start_date, end_date, user)
		time_off_total = calculate_days_to_deduct(start_date, end_date)
		
		deduct_from_totals(user, time_off_total)
	end

	def calculate_days_to_deduct(start_date, end_date)
		holidays = Holiday.all
		date_count = end_date.to_date.mjd - start_date.to_date.mjd
		time_off_total = 0
		0.upto(date_count) do |num|
			if num == 0
				time_off_total += 1 unless weekend?(start_date) || holiday?(start_date, holidays)
			else
				time_off_total += 1 unless weekend?(start_date + num.day) || holiday?(start_date + num.day, holidays)
			end
		end
		time_off_total
	end

	def deduct_time_from_hours(hours, user)
		user.update(personal_total: user.personal_total - hours)
	end

	def weekend?(date)
		date.on_weekend?
	end

	def holiday?(date, holidays)
		holidays.find_by_date(date.to_date) != nil
	end

	def deduct_from_totals(user, time_off_total)
		user.update(vacation_total: user.vacation_total - (time_off_total * 8))
	end

	def add_to_totals(user, time_off_total)
		user.update(vacation_total: user.vacation_total + (time_off_total * 8))
	end

	def add_time_from_cancel(start_date, end_date, user)
		time_off_total = calculate_days_to_deduct(start_date, end_date)
		
		add_to_totals(user, time_off_total)
	end

	def self.to_csv(data)
		csv_data = CSV.generate do |csv|
			csv << ["Employee", "Type", "Start Date", "End Date", "Approved By", "Hours"]
		  data.each do |request|
		    csv << ["#{request.user.first_name} #{request.user.last_name}", request.time_off_type, request.date_start.strftime("%m/%d/%Y"), request.date_end.strftime("%m/%d/%Y"), request.approved_by, request.hours.nil? ? 0 : request.hours]
		    request.status_changes.each do |status|
		    	csv << ["#{status.start_change}", "#{status.end_change}", "#{status.date.to_date.strftime('%m/%d/%Y')}"]
		    end
		  end
		end
	end
end
