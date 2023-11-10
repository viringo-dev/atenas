class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :bid, index: true, null: false
      t.string :payer, null: false

      t.timestamps
    end
  end
end
