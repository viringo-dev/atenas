class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, index: true
      t.string :surname, null: false, index: true
      t.string :username, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.integer :phone, null: false
      t.integer :phone_code, null: false, default: "51"
      t.integer :gender, null: false
      t.date :birthdate, null: false
      t.string :locale, default: :es
      t.string :country
      t.string :city
      t.datetime :deleted_at
      t.datetime :rgpd_accepted_at
      t.string :password_digest, null: false
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
