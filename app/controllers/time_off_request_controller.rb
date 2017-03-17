class TimeOffRequestController < ApplicationController

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
				flash[:notice] = "Vacation has been submitted to #{Manager.find(@request.manager_id).name}"
				redirect_to :root
			else
				flash[:error] = @request.errors
				redirect_to new_time_off_request_path
			end
		rescue => error
			flash[:error] = error
		end
	end

	def update
		@request = TimeOffRequest.find(params[:id])
		@request.approved = params[:status] == "approved" ? true : false
		@request.approved_by = "#{current_user.first_name} #{current_user.last_name}"

		if @request.save
			flash[:notice] = "Notification has been sent to #{@request.user.first_name} #{@request.user.last_name} about your decision."
		else
			flash[:error] = @request.errors
		end

		redirect_to :root
	end

	def destroy
	end

	private

	def time_off_params
		params.require(:request).permit(:manager_id, :time_off_type, :date_start, :date_end, :hours)
	end
end