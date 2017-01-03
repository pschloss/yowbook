class AddDamAndSireToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :dam, :string
    add_column :animals, :sire, :string
  end
end
