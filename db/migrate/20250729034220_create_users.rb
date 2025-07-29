class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :company, null: false
      t.integer :status, null: false, default: 1
      t.integer :role, null: false, default: 2
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
