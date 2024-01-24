class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.references :user, index: true, null: true, unique: true
      t.references :task, index: true, null: true, unique: true
      t.references :bid, index: true, null: true, unique: true
      t.float :value, null: false, default: 0
      t.text :comment
      t.integer :rate_type, null: false

      t.timestamps
    end
  end
end
