class RenameUsersToShepherds < ActiveRecord::Migration[5.0]
  def change
		rename_table :users, :shepherds
  end
end
