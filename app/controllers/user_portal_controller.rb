class UserPortalController < ApplicationController
  def index
  	@user = current_user
  	if @user.admin?
  		@manager = Manager.find_by_name("#{@user.first_name} #{@user.last_name}")
	  	@manager_approvals = @manager.time_off_requests.pending unless @manager.nil?
	  	@employees = @user.department.users
	  end
  	@pending_requests = @user.time_off_requests
  end
end
