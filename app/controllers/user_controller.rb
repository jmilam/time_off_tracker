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
		params.require(:user).permit(:first_name, :last_name, :admin, :email, :password, :password_confirmation, :vacation_total, :personal_total, :department_id)
	end
end