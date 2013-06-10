class AddCityColumnToPost < ActiveRecord::Migration
  def up
  	add_column :posts, :city, :string
  end
  def down
  	remove_column :posts, :city
  end
end
