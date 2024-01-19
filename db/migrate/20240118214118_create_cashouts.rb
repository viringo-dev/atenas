class CreateCashouts < ActiveRecord::Migration[7.0]
  def change
    create_table :cashouts do |t|
      t.references :task, index: true, null: true, unique: true
      t.references :bid, index: true, null: true, unique: true
      t.string :phone, null: false
      t.integer :wallet, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
