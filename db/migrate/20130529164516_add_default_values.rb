class AddDefaultValues < ActiveRecord::Migration
  def up
  	change_column :posts, :flagged, :boolean, :default => false
  	change_column :posts, :promoted, :boolean, :default => false
  end
end
