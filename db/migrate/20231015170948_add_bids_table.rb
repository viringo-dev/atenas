class AddBidsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :bids do |t|
      t.references :task, :user, index: true, null: false
      t.float :amount, null: false
      t.float :earning, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.index [:task_id, :user_id], unique: true

      t.timestamps
    end
  end
end
