class AddLocationToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :locations, :string, default: "NC"
  end
end
