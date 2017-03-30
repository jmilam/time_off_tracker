class HolidayController < ApplicationController
	def index
		@holidays = Holiday.all
	end

	def new
		@holiday = Holiday.new
	end

	def create
		@holiday = Holiday.new(holiday_params)

		if @holiday.save
			flash[:notice] = "Holiday successfully created."
		else
			flash[:error] = @holiday.errors
		end

		redirect_to holiday_index_path
	end

	def destroy
		@holiday = Holiday.find(params[:id])

		if @holiday.delete
			flash[:notice] = "Holiday successfully deleted."
		else
			flash[:error] = @holiday.errors
		end
		redirect_to holiday_index_path
	end
	private

	def holiday_params
		params.require(:holiday).permit(:name, :date)
	end

end