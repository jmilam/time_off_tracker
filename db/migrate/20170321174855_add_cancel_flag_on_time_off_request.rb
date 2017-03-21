class AddCancelFlagOnTimeOffRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :time_off_requests, :cancelled, :boolean, default: false
  end
end
