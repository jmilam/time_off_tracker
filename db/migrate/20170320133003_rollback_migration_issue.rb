class RollbackMigrationIssue < ActiveRecord::Migration[5.0]
  def change
  	remove_column :time_off_requests, :approved
  	add_column :time_off_requests, :approved, :boolean
  end
end
