class UserPortalController < ApplicationController
  def index
  	@user = current_user

  	@time_requests = @user.time_off_requests
  	@used_vac = @time_requests.vacation.inject(0) {|sum, request| sum + request.days_to_hours}
  	@used_personal = @time_requests.personal.inject(0) {|sum, request| sum + request.days_to_hours}
  	@pending_vac_total = @time_requests.vacation.pending.inject(0) {|sum, request| sum + request.days_to_hours}
  	@pending_personal_total = @time_requests.personal.pending.inject(0) {|sum, request| sum + request.days_to_hours}

  	if @user.admin?
  		@manager = Manager.find_by_name("#{@user.first_name} #{@user.last_name}")
	  	@manager_approvals = @manager.nil? ? Array.new : @manager.time_off_requests.pending
	  	@employees = @user.department.users.includes(:time_off_requests)
	  end
  	@pending_requests = @user.time_off_requests
  end
end
