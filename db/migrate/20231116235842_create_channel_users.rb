class CreateChannelUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_users do |t|
      t.datetime :last_read_at, default: -> { "CURRENT_TIMESTAMP" }, null: false
      t.references :channel, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
