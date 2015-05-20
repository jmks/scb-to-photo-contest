class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  # TODO: move to ContestRules
  # canada breaks photo submissions, but submissions are over now
  # these ideally should be disjoint choices
  CATEGORIES = [ :flora, :fauna, :landscapes, :canada ]

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

  # thumbnail related
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

  field :exhibitor, type: Boolean, default: false

  # scopes
  scope :landscapes,  ->{ where(category: "landscapes") }
  scope :flora,       ->{ where(category: "flora") }
  scope :fauna,       ->{ where(category: "fauna") }
  scope :category,    ->(cat) { cat == "canada" ? canada : where(category: cat) }
  scope :canada,      ->{ where(tags: /canada/i) }
  scope :recent,      ->{ desc(:created_at) }
  scope :tagged,      ->(tag) { where(tags: tag) }
  scope :most_viewed, ->{ desc(:views) }
  scope :most_voted,  ->{ desc(:votes) }

  # indexes
  index({ tags: 1 })
  index({ category: 1})
  index({ created_at: -1 })

  # TODO: category? implicitly downcases but category scope does not!
  def self.category? category
    return false if category.nil?
    category = category.to_s.downcase
    category == "canada" || Photo::CATEGORIES.map(&:to_s).map(&:downcase).include?(category)
  end

  def add_tag tag
    push tags: tag unless tagged? tag
  end

  def tagged? tag
    tags.include? tag
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

  # move to event machine
  def registration_status
    if !original_url
      :submitted
    elsif submission_complete
      :confirmed
    elsif order_number
      :printed
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
    tags.any?{ |t| t =~ /canada/i }
  end
end
