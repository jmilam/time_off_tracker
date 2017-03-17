class UserPortalController < ApplicationController
  def index
  	@user = current_user
  	@manager = Manager.find_by_name("#{@user.first_name} #{@user.last_name}")
  	@manager_approvals = @manager.time_off_requests.not_approved unless @manager.nil?
  	@employees = @manager.department.users
  	@pending_requests = @user.time_off_requests
  end
end
