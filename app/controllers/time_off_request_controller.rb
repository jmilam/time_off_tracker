class TimeOffRequestController < ApplicationController
	require 'net/http'
	def index
	end

	def new
		@user = current_user
		
		@managers = @user.department.managers
		@request_types = ["Personal", "Vacation"]
		@hours = @user.site == "Endura Products" ? ["4", "8"] : ["1","2","3","4","5","6","7","8"]
		
	end

	def edit
	end

	def create
		begin

			@request = current_user.time_off_requests.new(time_off_params)
			@request.user_id = params[:request][:requesting_user_id]
			manager = Manager.find_by_id(params[:request][:manager_id])
			user = manager.nil? ? nil : User.find_by_email(manager)
			params[:request][:manager_id] = user.nil? ? params[:request][:manager_id] : user.id
			if @request.save
				@request.status_changes.create(start_change: "New request", end_change: "Pending", date: Date.today)
				response = Api.new(Rails.env).manager_update(params[:request], current_user)
				flash[:notice] = "Vacation has been submitted to #{Manager.find(@request.manager_id).name}"
				redirect_to :root
			else
				flash[:error] = @request.errors
				redirect_to new_time_off_request_path
			end
		rescue => error
			flash[:error] = error
			redirect_to new_time_off_request_path
		end
	end

	def update
		begin
			@request = TimeOffRequest.find(params[:id])
			@start_status = @request.status
			@request.approved = params[:status] == "approved" ? true : false
			@request.approved_by = "#{current_user.first_name} #{current_user.last_name}"

			if @request.save
				@end_status = @request.status
				@request.status_changes.create(start_change: "#{@start_status}", end_change: "#{@end_status}", date: Date.today)
				if @request.time_off_type.downcase == "vacation"
					#@request.deduct_time_from_totals @request.date_start, @request.date_end, current_user
				else
					#@request.deduct_time_from_hours @request.hours, current_user
				end
				response = Api.new(Rails.env).user_update(@request)
				@exchange_server.add_to_calendar(@request) if @request.approved == true
				flash[:notice] = "Notification has been sent to #{@request.user.first_name} #{@request.user.last_name} about your decision."
			else
				flash[:error] = @request.errors
			end
		rescue => error
			flash[:error] = error
		end

		redirect_to :root
	end

	def destroy
	end

	def cancel
		begin
			@request = TimeOffRequest.find(params[:id])
			@start_status = @request.status
			if @request.update(cancelled: true)
				@end_status = @request.status
				@request.add_time_from_cancel @request.date_start, @request.date_end, current_user
				@request.status_changes.create(start_change: "#{@start_status}", end_change: "#{@end_status}", date: Date.today)
				flash[:notice] = "Time Off Request has been canceled."
			else
				flash[:error] = "There was an error when canceling Time Off Request."
			end
		rescue => error

			flash[:error] = "There was an error when canceling Time Off Request."
		end
		redirect_to :root
	end

	def tomorrow_requests
		@requests = TimeOffRequest.where(date_start: Date.tomorrow, approved: true, cancelled: false).includes(:user)
		respond_to do |format| 
			format.json {render json: {requests: @requests}}
		end
	end

	private

	def time_off_params
		params.require(:request).permit(:manager_id, :time_off_type, :date_start, :date_end, :hours, :cancelled, :approved, :approved_by, :note)
	end
end