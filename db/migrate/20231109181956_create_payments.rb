class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :task, index: true, null: false, unique: true
      t.references :bid, index: true, null: false, unique: true
      t.string :payer, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
