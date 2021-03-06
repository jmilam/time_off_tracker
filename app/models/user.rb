class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable#, :registerable, :recoverable,:validatable
  has_many :time_off_requests
  has_many :managers, through: :department
  belongs_to :department
  scope :all_current_employees, -> {where(terminated: false)}

  def user_totals
  	vacation = {available: self.vacation_total, used: 0, pending: 0}
  	personal = {available: self.personal_total,used: 0, pending: 0}
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

  	if time_off_request.approved && time_off_request.cancelled == false
  		totals[:used] += requested_time
  	elsif time_off_request.approved.nil? && time_off_request.cancelled == false
  		totals[:pending] += time_off_request.days_to_hours
  	else
  	end

  	time_off_request
  end

end
