class AddOrphanToAnimals < ActiveRecord::Migration[5.1]
  def change
    add_column :animals, :orphan, :boolean, :default => false
  end
end
