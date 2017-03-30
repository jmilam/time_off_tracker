require 'rails_helper'

RSpec.describe TimeOffRequestController, type: :controller do

	before :all do
		@department = FactoryGirl.build(:department)
		@manager = FactoryGirl.create(:manager, department: @department)
		@user = FactoryGirl.create(:endura_user, department: @department)
	end

	before :each do 
		sign_in @user
		post :create, params: {request: {manager_id: @manager.id, time_off_type: "Vacation", date_start: "2018-12-30", date_end: "2018-12-31"}}
	end

	after :all do
		@user.delete
		@manager.delete
	end

  describe "POST #create" do
    it "creates time off request" do
      @requests = @user.time_off_requests
      expect(@requests.count).to eq(1)
      expect(@requests.last.status_changes.count).to eq(1)
      expect(@requests.last.status_changes.last.start_change).to eq("New request")
      expect(@requests.last.status_changes.last.end_change).to eq("Pending")
      expect(@requests.last.status_changes.last.date).to eq(Date.today)
      expect(flash[:notice]).to eq("Vacation has been submitted to #{@manager.name}")
    end
  end

  describe "PUT #update" do
  	before :all do
  		@request = FactoryGirl.build(:time_off_request)
  		FactoryGirl.build(:status_change, time_off_request: @request)
  	end

  	before :each do
  		put :update, params: {id: @user.time_off_requests.last.id, status: "approved"}
  	end

  	it "updates time off request" do
      @requests = @user.time_off_requests
      
      expect(@requests.last.status_changes.count).to eq(2)
      expect(@requests.last.status_changes.last.start_change).to eq("Pending")
      expect(@requests.last.status_changes.last.end_change).to eq("Approved")
      expect(@requests.last.status_changes.last.date).to eq(Date.today)
      expect(flash[:notice]).to eq("Notification has been sent to #{@user.first_name} #{@user.last_name} about your decision.")
  	end

  	it "cancells time off request" do
  		put :cancel, params: {id: @user.time_off_requests.last.id, cancelled: true}
      @requests = @user.time_off_requests

      expect(@requests.last.status_changes.count).to eq(3)
      expect(@requests.last.status_changes.last.start_change).to eq("Approved")
      expect(@requests.last.status_changes.last.end_change).to eq("Cancelled")
      expect(@requests.last.status_changes.last.date).to eq(Date.today)
      expect(flash[:notice]).to eq("Time Off Request has been canceled.")
    end
  end
end