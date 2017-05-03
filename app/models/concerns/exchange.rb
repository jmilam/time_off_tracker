class Exchange
	require 'viewpoint'
	include Viewpoint::EWS

	def initialize(server, user, pass)
		@client = Viewpoint::EWSClient.new(server, user, pass)
		@calendar = @client.get_folder(:calendar)
		@it_fin_share = @client.get_folder_by_name 'Calendars', parent: :publicfoldersroot
		@it_fin_share = @it_fin_share.ews_item[:folder_id][:attribs][:id]
		@it_fin_share = @client.get_folder_by_name 'Finance/IT Out of Office', parent: @it_fin_share
	end

	def add_to_calendar(request)
		user = "#{request.user.first_name} #{request.user.last_name}"
		manager = request.approved_by
		type = request.time_off_type
		start_date = request.date_start
		end_date = request.date_end
		duration = request.hours

		time_zone = Time.now.localtime.zone
		time_zone = time_zone == 'EDT' ? 'EST' : time_zone
		
		
		if type.downcase == "vacation"	
			all_day = true
		end

		if duration.nil?
			start_date = (start_date.noon + 12.hours).in_time_zone(time_zone).iso8601
			end_date = (end_date.noon + 5.hours).in_time_zone(time_zone).iso8601
		else
			end_date = (start_date.noon + duration.hours).in_time_zone(time_zone).iso8601
			start_date = (start_date.noon).in_time_zone(time_zone).iso8601
		end

		@calendar.create_item(subject: "#{user} out. - #{type} Day", start: start_date, end: end_date, is_all_day_event: all_day, required_attendees: [{attendee: {mailbox: {email_address: request.user.email}}}])
		@it_fin_share.create_item(subject: "#{user} out. - #{type} Day", start: start_date, end: end_date, is_all_day_event: all_day)
		
	end
end