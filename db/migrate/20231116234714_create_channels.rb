class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels do |t|
      t.uuid :uuid, null: false, default: "gen_random_uuid()", index: { unique: true }
      t.integer :status, null: false, default: 0
      t.string :name, null: false
      t.references :task, index: true, null: false

      t.timestamps
    end
  end
end
