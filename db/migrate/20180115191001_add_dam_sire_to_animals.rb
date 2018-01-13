class AddDamSireToAnimals < ActiveRecord::Migration[5.1]
  def change
    add_column :animals, :dam_id, :int
    add_index :animals, :dam_id
    add_column :animals, :sire_id, :int
    add_index :animals, :sire_id
  end
end
