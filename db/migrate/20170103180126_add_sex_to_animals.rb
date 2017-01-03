class AddSexToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :sex, :string
  end
end
