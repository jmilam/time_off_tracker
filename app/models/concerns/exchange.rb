class Exchange
	require 'viewpoint'
	include Viewpoint::EWS

	def initialize(server, user, pass)
		@client = Viewpoint::EWSClient.new(server, user, pass)
		@calendar = @client.get_folder(:calendar)
	end

	def add_to_calendar(user, type, start_date, end_date, duration)
		time_zone = Time.now.localtime.zone
		time_zone = time_zone == 'EDT' ? 'EST' : time_zone
		
		
		if type.downcase == "vacation"	
			all_day = true
		end

		if duration.nil?
			start_date = (start_date.noon).in_time_zone(time_zone).iso8601
			end_date = (end_date.noon + 5.hours).in_time_zone(time_zone).iso8601
		else
			end_date = (start_date.noon + duration.hours).in_time_zone(time_zone).iso8601
			start_date = (start_date.noon).in_time_zone(time_zone).iso8601
		end

		@calendar.create_item(subject: "#{user.capitalize} out. - #{type} Day", start: start_date, end: end_date, is_all_day_event: all_day)
	end
end