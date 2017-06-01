class AddTerminatedFlagToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :terminated, :boolean, default: false
  end
end
