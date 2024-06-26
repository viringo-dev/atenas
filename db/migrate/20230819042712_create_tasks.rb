class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.uuid :uuid, null: false, default: "gen_random_uuid()", index: { unique: true }
      t.string :name, null: false
      t.text :description, null: false
      t.float :reward, null: false
      t.integer :currency, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.datetime :deadline, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
