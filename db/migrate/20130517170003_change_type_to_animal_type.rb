class ChangeTypeToAnimalType < ActiveRecord::Migration
  def up
  	rename_column :posts, :type, :animal_type
  end

  def down
  end
end
