class AddHourFieldToTimeOffRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :time_off_requests, :hours, :integer, default: 0
  end
end
