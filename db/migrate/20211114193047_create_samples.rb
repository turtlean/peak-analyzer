class CreateSamples < ActiveRecord::Migration[6.1]
  def change
    create_table :samples do |t|
      t.references :serie, null: false, foreign_key: true
      t.decimal :value, null: false

      t.timestamps
    end
  end
end
