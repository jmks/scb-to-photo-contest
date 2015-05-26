class Judge
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email, type: String
  validates :email, presence: true, uniqueness: true,
                 format: { with:    /\A.+@(.+\.)+\w{2,4}\Z/,
                           message: "%{value} is not a valid email" }

  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  scope :completed_scoring, ->{ where(photo_scoring_complete: true) }

  # personal info

  field :first_name, type: String
  validates :first_name, presence: true

  field :last_name, type: String
  validates :last_name, presence: true

  # juding actions

  has_many :photo_scores
  has_many :nominees
  has_and_belongs_to_many :contests

  # short lists
  has_and_belongs_to_many :flora_shortlist, class_name: 'Photo', inverse_of: nil
  has_and_belongs_to_many :fauna_shortlist, class_name: 'Photo', inverse_of: nil
  has_and_belongs_to_many :landscapes_shortlist, class_name: 'Photo', inverse_of: nil
  has_and_belongs_to_many :canada_shortlist, class_name: 'Photo', inverse_of: nil

  # flag that shortlist was completed / accepted
  field :shortlist_complete, type: Boolean, default: false

  # flag that photo scoring is complete
  field :photo_scoring_complete, type: Boolean, default: false

  def self.shortlist category
    # vs aggregation?
    return nil unless Photo::CATEGORIES.include? category
    Judge.all.map {|j| j.shortlist(category) }.flatten.uniq
  end

  def self.shortlist_by_category
    categories = Photo::CATEGORIES
    Hash[categories.zip(categories.map{ |c| Judge.shortlist(c) })]
  end

  # status, ie true if not completed shortlist
  def shortlist?
    !shortlist_complete
  end

  def shortlist_done? category
    shortlist(category).length == ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY
  end

  def update_shortlist_status
    done = Photo::CATEGORIES.map {|c| shortlist_done? c }.all?
    set(shortlist_complete: done) if done != shortlist_complete
  end

  def shortlist_photo photo, category=nil
    category ||= photo.category

    arr = shortlist(category)

    if arr.length < ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY && !arr.include?(photo)
      arr << photo
      update_shortlist_status
      true
    else
      false
    end
  end

  def remove_photo_from_shortlist photo, category=nil
    category ||= photo.category

    arr = shortlist(category)

    if arr.include?(photo)
      arr.delete(photo)
      update_shortlist_status
      true
    else
      false
    end
  end

  def shortlist category
    case category
    when :flora
      flora_shortlist
    when :fauna
      fauna_shortlist
    when :landscapes
      landscapes_shortlist
    when :canada
      canada_shortlist
    end
  end

  def current_contest
    return nil unless Contest.current
    (contests.include?(Contest.current) && Contest.current) || nil
  end

  # TODO raise exception if judge isn't part of current contest?
  def nominations_complete?(category=nil)
    if category
      nominees.where(category: category).count == current_contest.nominees_per_category
    else
      Photo::CATEGORIES.map {|cat| nominations_complete?(cat) }.all?
    end
  end

  def final_score_complete?
    Photo::CATEGORIES.map { |cat| Judge.shortlist(cat) }.
                      flatten.
                      map { |pho| PhotoScore.where(judge_id: id.to_s, photo_id: pho.id.to_s).first }.
                      all?
  end

  def status_message
    if photo_scoring_complete?
      'Final scoring complete'
    elsif shortlist_complete?
      'Shortlist picks complete'
    else
      'Has not started'
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
