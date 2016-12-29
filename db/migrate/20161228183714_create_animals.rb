class CreateAnimals < ActiveRecord::Migration[5.0]
  def change
    create_table :animals do |t|
      t.text :eartag
      t.references :shepherd, foreign_key: true

      t.timestamps
    end
		add_index :animals, [:shepherd_id, :created_at]
  end
end
