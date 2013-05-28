class AddUidToPost < ActiveRecord::Migration
  def up
  	add_column :posts, :uid, :integer
  end

  def down
  	remove_column :posts, :uid
  end
end
