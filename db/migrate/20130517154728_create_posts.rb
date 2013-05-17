class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :image
      t.string :name
      t.string :type
      t.string :state
      t.string :shelter
      t.boolean :flagged
      t.boolean :promoted
      t.integer :share_count
      t.text :story
      t.datetime :creation_time
      t.datetime :update_time
      t.boolean :adopted
      t.string :top_text
      t.string :bottom_text

      t.timestamps
    end
  end
end
