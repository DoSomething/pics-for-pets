class AddLengthToFbid < ActiveRecord::Migration
  def change
  	change_column :users, :uid, :bigint
  	change_column :users, :fbid, :bigint
  end
end
