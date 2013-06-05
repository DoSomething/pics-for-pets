class ChangeTextType < ActiveRecord::Migration
  def up
  	change_column :posts, :meme_text, :string
  	change_column :posts, :meme_position, :string
  end

  def down
  end
end
