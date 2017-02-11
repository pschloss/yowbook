class AddStatusToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :status, :character
		add_column :animals, :status_date, :date
  end
end
