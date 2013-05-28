class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :uid
      t.integer :post_id

      t.timestamps
    end
  end
end
