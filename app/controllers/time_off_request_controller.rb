class TimeOffRequestController < ApplicationController
	require 'net/http'
	def index
	end

	def new
		@user = current_user
		
		@managers = @user.department.managers
		@request_types = ["Personal", "Vacation"]
		@hours = ["1","2","3","4","5","6","7","8"]
		
	end

	def edit
	end

	def create
		begin
			@request = current_user.time_off_requests.new(time_off_params)
			
			if @request.save
				uri = URI(web_api + 'email/time_off_request/manager_update')
				response = Net::HTTP.post_form(uri, to_email: Manager.find(params[:request][:manager_id]).email, from_user: "#{current_user.first_name} #{current_user.last_name}", request_type: params[:request][:time_off_type], start_date: params[:request][:date_start], end_date: params[:request][:date_end], hours: params[:request][:hours])
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
			@request.approved = params[:status] == "approved" ? true : false
			@request.approved_by = "#{current_user.first_name} #{current_user.last_name}"

			if @request.save
				uri = URI(web_api + 'email/time_off_request/user_update')
				response = Net::HTTP.post_form(uri, to_email: @request.user.email, approved: @request.approved, approved_by: @request.approved_by, request_type: @request.time_off_type, start_date: @request.date_start, end_date: @request.date_end)
				@exchange_server.add_to_calendar(@request.approved_by, @request.time_off_type, @request.date_start,@request.date_end, @request.hours) if @request.approved == true
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
			if TimeOffRequest.update(params[:id], cancelled: true)
				flash[:notice] = "Time Off Request has been canceled."
			else
				flash[:error] = "There was an error when canceling Time Off Request."
			end
		rescue => error
			flash[:error] = "There was an error when canceling Time Off Request."
		end
		redirect_to :root
	end

	private

	def time_off_params
		params.require(:request).permit(:manager_id, :time_off_type, :date_start, :date_end, :hours, :cancelled, :approved, :approved_by)
	end
end