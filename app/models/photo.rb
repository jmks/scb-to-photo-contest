class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  CATEGORIES = [ :flora, :fauna, :landscapes ]

  # photo details fields
  field :title
  field :category,            :type => Symbol
  field :description
  field :camera_stats
  field :photo_date,          :type => Date
  field :photo_location
  embeds_many :comments
  field :tags,                :type => Array

  # photo logistics fields
  field :thumbnail_path
  field :original_path
  field :votes,               :type => Integer, :default => 0
  field :likes,               :type => Integer, :default => 0
  field :favourites,          :type => Integer, :default => 0

  # may be deprecated...
  field :approved_date,       :type => DateTime
  field :approved_by

  belongs_to :entry_photos, :class_name => 'Contestant', :inverse_of => :entries
  has_and_belongs_to_many :contestants, :inverse_of => :favourites

  # indexes
  # index "tags",     :unique => true, :sparse => true
  # index "category", :unique => true, :sparse => true
  # index "created_at"
end