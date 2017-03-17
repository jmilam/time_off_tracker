class CreateManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :managers do |t|
  		t.integer			:department_id
    	t.string			:name
      t.timestamps
    end
  end
end
