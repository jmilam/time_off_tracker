class Api
	require 'net/http'
	def initialize
		@web_api = "http://webapi.enduraproducts.com/api/endura/"
		#@web_api = "http://localhost:3000/api/endura/"
	end

	def manager_update(params, current_user)
		url = URI @web_api + 'email/time_off_request/manager_update'
		Net::HTTP.post_form url, to_email: Manager.find(params[:manager_id]).email, from_user: "#{current_user.first_name} #{current_user.last_name}", request_type: params[:time_off_type], start_date: params[:date_start], end_date: params[:date_end], hours: params[:hours]
	end

	def user_update(request)
		url = URI @web_api + 'email/time_off_request/user_update'
		Net::HTTP.post_form url, to_email: request.user.email, approved: request.approved, approved_by: request.approved_by, request_type: request.time_off_type, start_date: request.date_start, end_date: request.date_end
	end

	def upcoming_week_off(requests, managers, users)
		url = URI @web_api + 'email/reminder/upcoming_week_off'
		Net::HTTP.post_form url, requests: requests, managers: managers, users: users
	end

	def users_over_112_remaining(totals)
		url = URI @web_api + 'email/reminder/users_over_112'
		Net::HTTP.post_form url, data: totals
	end
end