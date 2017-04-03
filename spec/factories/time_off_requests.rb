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

  factory :time_off_incl_holiday, class: TimeOffRequest do
    id            3
    #manager_id    1
    time_off_type "Vacation"
    date_start    Date.new 2017, 11, 22
    date_end      Date.new 2017, 11, 25
  end

  factory :time_off_personal, class: TimeOffRequest do
    time_off_type "Personal"
    date_start    Date.today
    date_end      Date.today
    hours         4
  end
end
