class AddUsernameToShepherds < ActiveRecord::Migration[5.0]
  def change
    add_column :shepherds, :username, :string
    add_index :shepherds, :username, unique: true
  end
end
