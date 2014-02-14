class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  CATEGORIES = [ :flora, :fauna, :landscapes ]

  # photo details fields
  field :title
  validates :title, presence: true

  field :category
  validates :category, presence:  true, 
                       inclusion: { in: %w(flora fauna landscapes), 
                                    message: "%{value} is not a valid category"}

  field :description
  
  field :camera_stats
  field :photo_date, :type => Date
  field :photo_location
  
  embeds_many :comments
  field :tags, :type => Array, :default => []

  # photo logistics fields -- will change
  field :thumbnail_path
  field :original_path

  field :votes, :type => Integer, :default => 0
  field :likes, :type => Integer, :default => 0
  field :favourites, :type => Integer, :default => 0

  belongs_to :owner, :class_name => 'Contestant', :inverse_of => :entries
  validates :owner, presence: true
  
  has_and_belongs_to_many :contestants, :class_name => 'Contestant', :inverse_of => :favourites

  # scopes
  scope :landscapes, ->{ where(:category => "landscapes") }
  scope :flora,      ->{ where(:category => "flora") }
  scope :fauna,      ->{ where(:category => "fauna") }

  # indexes
  index({ tags: 1 })
  index({ category: 1})
  index({ created_at: -1 })

  def add_tag tag
    
  end
end