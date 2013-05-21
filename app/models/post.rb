class Post < ActiveRecord::Base
  attr_accessible :adopted, :bottom_text, :creation_time,
  	:flagged, :image, :name, :promoted,
  	:share_count, :shelter, :state,
  	:story, :top_text, :animal_type, :update_time

  validates :name,    :presence => true
  validates :shelter, :presence => true
  validates :animal_type,    :presence => true
  validates :state,   :presence => true,
                      :length => { :maximum => 2 }
  validates :shelter, :presence => true

  has_attached_file :image, :styles => { :gallery => '450x450!' }, :default_url => '/images/:style/default.png'
  validates_attachment :image, :presence => true, :content_type => { :content_type => ['image/jpeg', 'image/png', 'image/gif'] }
end
