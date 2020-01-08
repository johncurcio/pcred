class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.integer :user_id
      t.string :website
      t.text :password_cipher
      t.text :iv
      t.text :temp_code

      t.timestamps null: false
    end
  end
end
