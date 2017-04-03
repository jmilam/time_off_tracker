FactoryGirl.define do
  factory :thanksgiving, class: Holiday do
  	name			"Thanksgiving"
  	date			Date.new 2017,11,23
    
  end
end
