class AddPhoneNameEmailAgePatient < ActiveRecord::Migration
  def up
  	add_column :patients, :phone, :string
  	add_column :patients, :email, :string
  	add_column :patients, :age, :integer
  	add_column :patients, :gender, :string
  end

  def down
  	remove_column :patients, :phone
  	remove_column :patients, :email
  	remove_column :patients, :age
  	remove_column :patients, :sender
  end
end
