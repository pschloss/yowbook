class RemoveDamSireFromAnimals < ActiveRecord::Migration[5.1]
  def change
    remove_column :animals, :dam, :string
    remove_column :animals, :sire, :string
  end
end
