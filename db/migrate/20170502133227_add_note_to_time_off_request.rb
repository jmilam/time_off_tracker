class AddNoteToTimeOffRequest < ActiveRecord::Migration[5.0]
  def change
  	add_column :time_off_requests, :note, :string
  end
end
