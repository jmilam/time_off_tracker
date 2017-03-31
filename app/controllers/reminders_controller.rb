class RemindersController < ApplicationController
	skip_before_action :authenticate_user!
	def create
		case params[:type].downcase

		when "upcoming_week"
			managers, users = Array.new, Array.new
			requests = TimeOffRequest.upcoming_week.includes(:manager, :user)
			requests.each do |r| 
				managers << r.manager
				users << r.user
			end 
			Api.new.upcoming_week_off requests.to_json, managers.to_json, users.to_json
		when "outstanding_time_off"
			totals= Hash.new

			User.all.each do |user|
			  total = user.personal_total + user.vacation_total  
				if total >= 112 
					manager = Manager.find_by_id(user.department.id)
					if totals.keys.include?(manager.email)
						#otals[manager.email][0] << {outstanding: total, name: "#{user.first_name} #{user.last_name}", email: user.email}
					else
						totals[manager.email] = [{outstanding: total, name: "#{user.first_name} #{user.last_name}", email: user.email}]
					end
				end
			end
			Api.new.users_over_112_remaining totals
		else
		end
	end
end
