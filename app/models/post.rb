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

  def self.per_page
    10
  end

  # Removes HTML tags.  This technically will automatically be sanitized,
  # but better safe than sorry.
  before_save :strip_tags
  def strip_tags
    self.name = self.name.gsub(/\<[^\>]+\>/, '')
    self.shelter = self.shelter.gsub(/\<[^\>]+\>/, '')
    self.top_text = self.top_text.gsub(/\<[^\>]+\>/, '')
    self.bottom_text = self.bottom_text.gsub(/\<[^\>]+\>/, '')
  end
end
