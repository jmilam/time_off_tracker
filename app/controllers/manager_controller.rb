class ManagerController < ApplicationController

	def index
		@managers = Manager.all.sort_by {|manager| manager.department.name }
	end

	def new
		@manager = Manager.new
		@departments = Department.all
	end

	def edit
		@manager = Manager.find(params[:id])
		@departments = Department.all
	end

	def show
	end

	def create
		@manager = Manager.new(manager_params)
		if @manager.save
			flash[:notice] = "Manager was successfully created"
		else
			flash[:error] = @manager.errors
		end	
		redirect_to new_manager_path
	end

	def update
		if Manager.update(params[:id], manager_params)
			flash[:notice] = "Manager informatin was successfully updated"
		else
			flash[:error] = "Error when trying to update"
		end
		redirect_to manager_index_path
	end

	def destroy
		@manager = Manager.find(params[:id])

		if @manager.delete
			flash[:notice] = "Manager was deleted"
		else
			flash[:error] = @manager.error
		end
		redirect_to manager_index_path
	end

	private

	def manager_params
		params.require(:manager).permit(:name, :email, :department_id)
	end
end