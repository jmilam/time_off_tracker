class ReportController < ApplicationController
	def index
		case params[:report]
		when "next_week"
			date_start = Date.today.next_week
			date_end = Date.today.next_week.end_of_week
		when "current_month"
			date_start = Date.today.beginning_of_month
			date_end = Date.today.next_week.end_of_month
		when "next_month"
			date_start = Date.today.end_of_month + 1.day
			date_end = (Date.today.end_of_month + 1.day).end_of_month
		end

		@requests = TimeOffRequest.approved_report(date_start, date_end).includes(:user, :manager).order('time_off_type ASC')
		@report_type = params[:report]
		respond_to do |format|
			format.html
			format.js
		end
	end

	def create
		case params[:report]
		when "next_week"
			date_start = Date.today.next_week
			date_end = Date.today.next_week.end_of_week
		when "current_month"
			date_start = Date.today.beginning_of_month
			date_end = Date.today.next_week.end_of_month
		when "next_month"
			date_start = Date.today.end_of_month + 1.day
			date_end = (Date.today.end_of_month + 1.day).end_of_month
		end

		@requests = TimeOffRequest.approved_report(date_start, date_end).includes(:user).order('time_off_type ASC')
		@requests = TimeOffRequest.to_csv(@requests)

		send_data @requests, filename: "#{params[:report]} Requests.csv"

		respond_to do |format|
			format.html
		end

	end
end