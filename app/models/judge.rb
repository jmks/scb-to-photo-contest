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

  # personal info

  field :first_name, type: String
  validates :first_name, presence: true

  field :last_name, type: String
  validates :last_name, presence: true

  # juding actions

  # short lists
  has_many :flora_shortlist, class_name: 'Photo', inverse_of: :flora_shortlisted
  has_many :fauna_shortlist, class_name: 'Photo', inverse_of: :fauna_shortlisted
  has_many :landscapes_shortlist, class_name: 'Photo', inverse_of: :landscapes_shortlisted
  has_many :canada_shortlist, class_name: 'Photo', inverse_of: :canada_shortlisted

  field :shortlist_complete, type: Boolean, default: false

  # photo scoring

  field :final_photo_scoring, type: Boolean, default: false

  def shortlist_photo photo, category=nil
    category ||= photo.category
    category = category.to_sym unless category.is_a?(Symbol)

    arr = if category == :flora 
      flora_shortlist
    elsif category == :fauna
      fauna_shortlist
    elsif category == :landscapes
      landscapes_shortlist
    else # canada
      canada_shortlist
    end

    if arr.length < ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY && !arr.include?(photo)
      arr << photo
      true
    else
      false
    end
  end

  def remove_photo_from_shortlist photo, category=nil
    category ||= photo.category
    category = category.to_sym unless category.is_a?(Symbol)

    arr = if category == :flora 
      flora_shortlist
    elsif category == :fauna
      fauna_shortlist
    elsif category == :landscapes
      landscapes_shortlist
    else # canada
      canada_shortlist
    end

    if arr.include?(photo)
      arr.delete(photo)
      true
    else
      false
    end
  end

  def status_message
    if final_photo_scoring?
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

  def shortlist?
    !shortlist_complete
  end
end
