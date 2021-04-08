class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :user_id
      t.string :id_token
      t.string :remember_digest

      t.timestamps
    end
  end
end
