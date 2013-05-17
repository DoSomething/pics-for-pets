class ChangeTypeToAnimalType < ActiveRecord::Migration
  def self.up
  	rename_column :posts, :type, :animal_ype
  end

  def self.down
  end
end
