class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :user_id
      t.string :remember_digest

      t.string :access_token
      t.integer :expires_in
      t.string :id_token

      t.timestamps
    end
  end
end
