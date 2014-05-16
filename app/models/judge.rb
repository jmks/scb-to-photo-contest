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
  field :flora_shortlist_ids,      type: Array, default: []
  field :fauna_shortlist_ids,      type: Array, default: []
  field :landscapes_shortlist_ids, type: Array, default: []
  field :canada_shortlist_ids,     type: Array, default: []

  field :shortlist_complete, type: Boolean, default: false


  # photo scoring

  field :final_photo_scoring, type: Boolean, default: false

  def shortlist_photo photo, category=nil
    category ||= photo.category

    arr = case category
    when :flora
      flora_shortlist_ids
    when :fauna
      fauna_shortlist_ids
    when :landscapes
      landscapes_shortlist_ids
    else # canada
      canada_shortlist_ids
    end

    return false if arr.length >= ContestRules::JUDGING_SHORTLIST_MAX_PER_CATEGORY || arr.include?(photo.id)

    arr << photo.id
    true
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
end
