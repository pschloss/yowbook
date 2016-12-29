class AddPictureToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :picture, :string
  end
end
