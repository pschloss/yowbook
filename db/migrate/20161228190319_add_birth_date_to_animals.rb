class AddBirthDateToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :birth_date, :date
  end
end
