class CreateTimeOffRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :time_off_requests do |t|
    	t.integer				:user_id
    	t.string 				:manager_name
    	t.string				:time_off_type
    	t.datetime			:date_start
    	t.datetime			:date_end
    	t.boolean				:approved
    	t.string				:approved_by

      t.timestamps
    end
  end
end
