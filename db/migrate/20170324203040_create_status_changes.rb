class CreateStatusChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :status_changes do |t|
    	t.integer 	:time_off_request_id
    	t.string 		:start_change
    	t.string		:end_change
    	t.datetime 	:date
      t.timestamps
    end
  end
end
