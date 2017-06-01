class UserPortalController < ApplicationController
  def index
  	@user = current_user

  	@time_requests = @user.time_off_requests.order 'date_start DESC'
    
  	@used_vac = @time_requests.vacation.approved.inject(0) {|sum, request| sum + request.days_to_hours}
  	@used_personal = @time_requests.personal.approved.inject(0) {|sum, request| sum + request.days_to_hours}


  	@pending_vac_total = @time_requests.vacation.pending.inject(0) {|sum, request| sum + request.days_to_hours}
  	@pending_personal_total = @time_requests.personal.pending.inject(0) {|sum, request| sum + request.days_to_hours}

    @time_requests = @time_requests.partition { |request| request.approved.nil?}
    @time_requests[1] = @time_requests[1].sort! {|x, y| y.date_start <=> x.date_start}

  	if @user.admin?
  		@manager = Manager.find_by_name("#{@user.first_name} #{@user.last_name}")
	  	@manager_approvals = @manager.nil? ? Array.new : @manager.time_off_requests.pending
	  	@employees = @user.department.users.all_current_employees.includes(:time_off_requests)
    elsif @user.payroll
      @manager_approvals = TimeOffRequest.pending
      @employees = User.all_current_employees.includes(:time_off_requests)
	  end
  	@pending_requests = @user.time_off_requests
  end
end
