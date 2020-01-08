class CreateAccessLogs < ActiveRecord::Migration
  def change
    create_table :access_logs do |t|
      t.integer :user_id
      t.string :access_class
      t.string :action
      t.integer :active_on_id
      t.text :message
      t.string :signature

      t.timestamps null: false
    end
  end
end
