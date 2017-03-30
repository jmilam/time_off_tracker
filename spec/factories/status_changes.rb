FactoryGirl.define do
  factory :status_change do
    time_off_request
    id 							1
    start_change		"New request"
    end_change			"Pending"
    date						Date.today
  end
end
