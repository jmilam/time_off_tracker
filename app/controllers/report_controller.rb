class ReportController < ApplicationController
	def index
		report_func = 0
		@start_date = params[:start_date]
		@end_date = params[:end_date]
		case params[:report]
		when "time_off_request_report"

		when "transaction_report"
			report_func = 1
		end

		if report_func == 0
			@requests = TimeOffRequest.approved_report(@start_date,@end_date).includes(:user, :manager, :status_changes).order('date_start ASC')
		else
			@requests = TimeOffRequest.where('date_start >= ? AND date_end <= ?', @start_date, @end_date).includes(:status_changes).order('date_start ASC')
		end
		
		@report_type = params[:report]
		
		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		begin
			start_date = params[:start_date]
			end_date = params[:end_date]
			case params[:report]
			when "time_off_request_report"
				@requests = TimeOffRequest.approved_report(start_date, end_date).includes(:user).order('time_off_type ASC')
			when "transaction_report"
				@requests = TimeOffRequest.where('date_start >= ? AND date_end <= ?', start_date, end_date).includes(:status_changes).order('date_start ASC')
			end
			@requests = TimeOffRequest.to_csv(@requests)
			send_data @requests, filename: "#{params[:report]} Requests.csv"

		rescue => error
			flash[:error] = error
			redirect_to report_index_path
		end

	end
end