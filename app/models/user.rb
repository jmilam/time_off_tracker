class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :time_off_requests
  has_many :managers, through: :department
  belongs_to :department

  def user_totals
  	vacation = {available: self.vacation_total, approved_not_taken: 0, used: 0, pending: 0}
  	personal = {available: self.personal_total, approved_not_taken: 0,used: 0, pending: 0}
  	self.time_off_requests.each do |request|
  		case request.time_off_type
  		when "Personal"
  			status(request, personal)
  		when "Vacation"
  			status(request, vacation)
  		end
  	end
  	{personal: personal, vacation: vacation}
  end

  def status(time_off_request, totals)
  	requested_time = time_off_request.days_to_hours

  	if time_off_request.approved && time_off_request.cancelled == false && time_off_request.date_start < Date.today
  		totals[:used] += requested_time
    elsif time_off_request.approved && time_off_request.cancelled == false && time_off_request.date_start > Date.today
      totals[:approved_not_taken] += requested_time
  	elsif time_off_request.approved.nil? && time_off_request.cancelled == false
  		totals[:pending] += time_off_request.days_to_hours
  	else
  	end
  	#totals[:available] -= requested_time
  	time_off_request
  end

end
