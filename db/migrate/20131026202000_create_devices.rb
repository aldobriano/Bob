class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
    	t.integer :patient_id
    	t.string  :access_token
    	t.integer :max_threshold
    	t.integer :min_threshold
    	t.string :type
      t.timestamps
    end
  end
end
