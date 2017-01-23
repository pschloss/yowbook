class CreateWeights < ActiveRecord::Migration[5.0]
  def change
    create_table :weights do |t|
      t.decimal :weight
      t.string :weight_type
      t.date :date
      t.references :animal, foreign_key: true

      t.timestamps
    end

		add_index :weights, [:animal_id, :created_at]

  end
end
