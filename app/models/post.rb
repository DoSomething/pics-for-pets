class Post < ActiveRecord::Base
  attr_accessible :uid, :adopted, :bottom_text, :creation_time,
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

  has_many :shares

  def self.per_page
    10
  end

  # Removes HTML tags.  This technically will automatically be sanitized,
  # but better safe than sorry.
  before_save :strip_tags
  def strip_tags
    self.name = self.name.gsub(/\<[^\>]+\>/, '')
    self.shelter = self.shelter.gsub(/\<[^\>]+\>/, '')

    if !self.top_text.nil?
      self.top_text = self.top_text.gsub(/\<[^\>]+\>/, '')
    end
    if !self.bottom_text.nil?
      self.bottom_text = self.bottom_text.gsub(/\<[^\>]+\>/, '')
    end
  end

  def self.as_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  after_save :touch_cache
  def touch_cache
    # We need to clear all caches -- Every cache depends on the one before it.
    Rails.cache.clear
  end
end
