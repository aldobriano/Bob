class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.integer :patient_id
    	t.string :email
    	t.string :phone
    	t.string :relationship
    	t.string :password
      t.timestamps
    end
  end
end
