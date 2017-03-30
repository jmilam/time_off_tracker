FactoryGirl.define do
  factory :endura_user, class: User do
    department
    id							1
    email						"jmilam@enduraproducts.com"
    first_name			"Test"
    last_name				"Spec"
    password				"test1234"
    admin						true
    vacation_total 	100
    personal_total	100
    payroll					false
    account_manager	true
    site						"Endura Products"
  end
end