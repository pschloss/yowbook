class AddActiveToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :active, :boolean, :default => TRUE
  end
end
