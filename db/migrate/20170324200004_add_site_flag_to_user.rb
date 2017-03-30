class AddSiteFlagToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :site, :string, default: 'Endura Products'
  end
end
