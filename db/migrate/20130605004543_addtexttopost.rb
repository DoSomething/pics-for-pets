class Addtexttopost < ActiveRecord::Migration
  def up
  	add_column :posts, :meme_text, :text
  	add_column :posts, :meme_position, :text
  end

  def down
  end
end
