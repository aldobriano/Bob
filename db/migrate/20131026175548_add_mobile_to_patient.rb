class AddMobileToPatient < ActiveRecord::Migration
  def change
  	add_column :patients, :mobile, :string
  end
end
