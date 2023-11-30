class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :resource_type, null: false
      t.integer :resource_id, null: false
      t.integer :notification_type, null: false
      t.string :path, null: false
      t.boolean :readed, null: false, default: false
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
