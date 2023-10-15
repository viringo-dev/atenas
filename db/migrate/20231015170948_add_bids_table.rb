class AddBidsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :bids do |t|
      t.references :task, :user, index: true, null: false
      t.float :amount, null: false

      t.timestamps
    end
  end
end
