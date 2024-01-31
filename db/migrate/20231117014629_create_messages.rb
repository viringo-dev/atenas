class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content, null: true
      t.references :channel, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
