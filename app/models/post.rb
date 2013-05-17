class Post < ActiveRecord::Base
  attr_accessible :adopted, :bottom_text, :creation_time, :flagged, :image, :name, :promoted, :share_count, :shelter, :state, :story, :top_text, :type, :update_time
end
