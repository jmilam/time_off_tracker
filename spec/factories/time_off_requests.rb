FactoryGirl.define do
  factory :time_off_request do
    id 							1
    time_off_type		"Vacation"
    date_start			Date.today + 1.day
    date_end				Date.today + 2.day
  end

  factory :next_week_request, class: TimeOffRequest do
  	id							2
  	manager_id			1
  	time_off_type		"Vacation"
  	date_start			Date.today.next_week.beginning_of_week + 2.days
  	date_end				Date.today.next_week.beginning_of_week + 4.days
    approved        true
  end


end
