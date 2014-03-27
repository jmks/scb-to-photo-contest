class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  # move to ContestRules
  CATEGORIES = [ :flora, :fauna, :landscapes ]
  
  Registration = [ :submitted, :uploaded, :printed, :confirmed ]
  Registration_Message = {
    :submitted => 'Upload Your Photo',
    :uploaded  => 'Print & Verify',
    :printed   => 'Awaiting Printed Copy',
    :confirmed => 'Registration Complete'
  }

  # photo details fields
  field :title
  validates :title, presence: true

  field :category
  validates :category, presence:  true, 
                       inclusion: { in: CATEGORIES, 
                                    message: "%{value} is not a valid category" }

  field :description
  
  field :camera_stats
  field :photo_date
  field :photo_location

  validates :terms_of_service, acceptance: true
  
  embeds_many :comments
  field :tags, :type => Array, :default => []

  field :original_url
  field :original_filename # not useful

  # thumbnail related -- will update
  field :thumbnail_url # not useful

  field :thumbnail_xs_url
  field :thumbnail_sm_url
  field :thumbnail_lg_url

  # registration details
  field :order_number

  field :votes, type: Integer, default: 0
  field :views, type: Integer, default: 0

  belongs_to :owner, :class_name => 'Contestant', :inverse_of => :entries
  validates  :owner, presence: true
  
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

  def original_key
    if original_url?
      CGI::unescape(original_url.split(/scbto-photos-originals\//).last)
    else
      nil
    end
  end

  # sizes: [:xs, :sm, :lg]
  def aws_key size
    id.to_s + "-#{size.to_s}"
  end

  def registration_status
    if !original_url
      :submitted
    elsif order_number
      :confirmed
    else
      :uploaded
    end
  end
end