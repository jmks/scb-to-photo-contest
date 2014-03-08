class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  CATEGORIES = [ :flora, :fauna, :landscapes ]

  #mount_uploader :photo, PhotoEntryUploader
  #field :photo

  # photo details fields
  field :title
  validates :title, presence: true

  field :category
  validates :category, presence:  true, 
                       inclusion: { in: CATEGORIES, 
                                    message: "%{value} is not a valid category"}

  field :description
  
  field :camera_stats
  field :photo_date
  field :photo_location

  validates :terms_of_service, acceptance: true
  
  embeds_many :comments
  field :tags, :type => Array, :default => []

  field :original_url
  field :original_filename

  # thumbnail related -- will update
  field :thumbnail_url

  field :votes,       type: Integer, default: 0
  field :views,       type: Integer, default: 0

  belongs_to :owner, :class_name => 'Contestant', :inverse_of => :entries
  validates :owner, presence: true
  
  # scopes
  scope :landscapes, ->{ where(:category => "landscapes") }
  scope :flora,      ->{ where(:category => "flora") }
  scope :fauna,      ->{ where(:category => "fauna") }

  # indexes
  index({ tags: 1 })
  index({ category: 1})
  index({ created_at: -1 })

  def add_tag tag
    unless tagged? tag
      push tags: tag
    end
  end

  def tagged? tag
    if tags?
      tags.include? tag
    else
      false
    end
  end
end