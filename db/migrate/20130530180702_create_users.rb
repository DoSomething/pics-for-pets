class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :fbid
      t.integer :uid
      t.string :email

      t.timestamps
    end
  end
end
