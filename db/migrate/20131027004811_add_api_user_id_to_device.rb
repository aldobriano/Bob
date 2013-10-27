class AddApiUserIdToDevice < ActiveRecord::Migration
  def change
  	add_column :devices, :api_user_id, :string
  end
end
