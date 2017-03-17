class ChangeManagerNameToManagerId < ActiveRecord::Migration[5.0]
  def change
  	remove_column :time_off_requests, :manager_name
  	add_column :time_off_requests, :manager_id, :integer
  end
end
