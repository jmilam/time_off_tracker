class AddFlagsToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :payroll, :boolean, default: false
  	add_column :users, :account_manager, :boolean, default: false
  end
end
