require 'rails_helper'

RSpec.describe RemindersController, type: :controller do

	before :all do
		@department = FactoryGirl.build(:department)
		@manager = FactoryGirl.create(:manager, department: @department)
		@user = FactoryGirl.create(:endura_user, department: @department)
		@request = FactoryGirl.create(:next_week_request, user: @user)
	end

	after :all do
		@manager.delete
		@request.delete
		@user.delete
	end

  describe "POST #create" do
    describe "sends email reminder based off param[:type]" do
    	it "should update all users/managers for time off requests in upcoming week" do
      	post :create, params: {type: 'upcoming_week'}
      	expect(TimeOffRequest.upcoming_week.count).to eq(1)
      end
    end

    describe "sends email reminder of outstanding time available" do
    	it "should update all maangers for employees with time off totals more then 112 hours" do
    		post :create, params: {type: 'outstanding_time_off'}
    	end
    end
  end
end
