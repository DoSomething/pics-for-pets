class AddIntentColumn < ActiveRecord::Migration
  def up
    add_column :users, :intent, :boolean
  end

  def down
    remove_column :users, :intent
  end
end
