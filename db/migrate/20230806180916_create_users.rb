class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, index: true
      t.string :surname, null: false, index: true
      t.string :slug, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :phone
      t.string :phone_code, default: "51"
      t.integer :gender
      t.date :birthdate
      t.string :locale, default: :es
      t.string :country
      t.string :city
      t.datetime :deleted_at
      t.boolean :rgpd_accepted, null: false, default: false
      t.string :password_digest, null: false
      t.datetime :confirmed_at
      t.float :rating, null: false, default: 0
      t.boolean :avo_access, null: false, default: false

      t.timestamps
    end
  end
end
