class AddVacationAndSickTotalsToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :vacation_total, :integer, default: 0
  	add_column :users, :personal_total, :integer, default: 0
  end
end
