class DepartmentController < ApplicationController
	def index
		@departments = Department.all
	end

	def new
	end

	def edit
		@department = Department.find(params[:id])
	end

	def create
		@department = Department.new(department_params)

		if @department.save
			flash[:notice] = "Department was successfully created."
		else
			flash[:error] = @department.errors
		end

		redirect_to department_index_path
	end

	def update
		if Department.update(params[:id], department_params)
			flash[:notice] = "Department was successfully updated."
		else
			flash[:error] = "Error when updating deparment, please try again."
		end
		redirect_to department_index_path
	end

	def destroy
		@department = Department.find(params[:id])

		if @department.delete
			flash[:notice] = "Department has been successfully deleted."
		else
			flash[:error] = @department.errors
		end

		redirect_to department_index_path
	end

	private

	def department_params
		params.require(:department).permit(:name)
	end

end