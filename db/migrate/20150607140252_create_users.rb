class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.datetime :last_seen_at

      t.timestamps null: false
    end
  end
end
