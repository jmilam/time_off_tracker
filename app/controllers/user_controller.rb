class UserController < ApplicationController

	def index
		@users = User.all
	end

	def new
		@departments = Department.all
		@user = User.new
	end

	def edit
		@user = User.find(params[:id])
		@departments = Department.all
	end

	def show
		@counter = 0
		@user = User.find(params[:id])
		@managers = Manager.all
		@request_types = ["Personal", "Vacation"]
		@hours = @user.site == "Endura Products" ? ["4", "8"] : ["1","2","3","4","5","6","7","8"]
		@requests = @user.time_off_requests.order("date_start ASC").group_by(&:time_off_type)
		@personal_count = @requests.empty? ? 0 : @requests["Personal"].count unless @requests["Personal"].nil?
		@vacation_count = @requests.empty? ? 0 : @requests["Vacation"].count unless @requests["Vacation"].nil?
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:notice] = "User successfully updated"
			redirect_to user_index_path
		else
			flash[:error] = @user.errors
			redirect_to new_user_path
		end
	end


	def update
		params[:user][:payroll] = params[:user][:payroll].nil? ? false : true
		params[:user][:admin] = params[:user][:admin].nil? ? false : true
		params[:user][:account_manager] = params[:user][:account_manager].nil? ? false : true

		@user = User.update(params[:id], user_params)
		if @user
			flash[:notice] = "User successfully updated"
			redirect_to user_index_path
		else
			flash[:error] = @user.errors
			redirect_to edit_user_path(params[:id])
		end
	end

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :admin, :email, :password, :password_confirmation, :vacation_total, :personal_total, :department_id, :payroll, :account_manager)
	end
end