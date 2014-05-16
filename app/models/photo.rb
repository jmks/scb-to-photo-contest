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
  
  embeds_many :comments
  field :tags, :type => Array, :default => []

  field :original_url
  field :original_filename # not useful

  # want equiv of this, but this is too slow
  #field :thumbnails, type: Boolean, default: false

  # thumbnail related -- will update
  field :thumbnail_url # not useful

  field :thumbnail_xs_url
  field :thumbnail_sm_url
  field :thumbnail_lg_url

  # registration details
  field :order_number

  field :submission_complete, type: Boolean, default: ->{ registration_status == :confirmed || false }

  field :votes, type: Integer, default: 0
  field :views, type: Integer, default: 0

  belongs_to :owner, :class_name => 'Contestant', :inverse_of => :entries
  validates  :owner, presence: true

  belongs_to :flora_shortlisted, inverse_of: :flora_shortlist, class_name: 'Judge'
  belongs_to :fauna_shortlisted, inverse_of: :fauna_shortlist, class_name: 'Judge'
  belongs_to :landscapes_shortlisted, inverse_of: :landscapes_shortlist, class_name: 'Judge'
  belongs_to :canada_shortlisted, inverse_of: :canada_shortlist, class_name: 'Judge'
  
  # scopes
  scope :landscapes, ->{ where(:category => "landscapes") }
  scope :flora,      ->{ where(:category => "flora") }
  scope :fauna,      ->{ where(:category => "fauna") }
  scope :canada,     ->{ where(tags: /canada/i) }

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
    elsif order_number || submission_complete
      :confirmed
    else
      :uploaded
    end
  end

  CATEGORIES.each do |cat|
    define_method(cat.to_s + '?') do
      self.category == cat
    end
  end

  def canada?
    tags.select { |t| t =~ /canada/i }.any?
  end
end