FactoryGirl.define do
  factory :time_off_request do
    id 							1
    time_off_type		"Vacation"
    date_start			Date.today + 1.day
    date_end				Date.today + 2.day
  end
end
