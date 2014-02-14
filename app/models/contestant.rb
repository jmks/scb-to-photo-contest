class Contestant
  include Mongoid::Document
  include Mongoid::Timestamps

  # Devise

  # Include default devise modules. Others available are:
    # :token_authenticatable, :encryptable,
    # :confirmable, :lockable, :timeoutable and
    # :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String
  validates_confirmation_of :email
  validates :email, presence: true, uniqueness: true,
                 format: { with:    /\A.+@(.+\.)+\w{2,4}\Z/, 
                           message: "%{value} is not a valid email" }
                           
  field :encrypted_password
  validates :encrypted_password, presence: true

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  # Token authenticatable
  # field :authentication_token, :type => String

  ## Invitable
  # field :invitation_token, :type => String

  field :first_name
  validates :first_name, presence: true

  field :last_name
  validates :last_name, presence: true

  # phone required for photo submission
  field :phone
  before_validation :normalize_phone, if: :phone?
  validates :phone, format: { with: /\A\d{3}-\d{3}-\d{4}(?:x\d+)?\z/,
                              message: 'format is not recognized' },
                    allow_blank: true

  has_many :entries, :class_name => "Photo", :inverse_of => :entry_photos
  
  # has_and_belongs_to_many :favourites, :class_name => "Photo", :inverse_of => :favourite_photos
  field :favourite_photo_ids, :type => Array, :default => []

  # indexes
  index({ email: 1 }, { unique: true, background: true })

  def favourite_photo photo
    if favourite_photo_ids.nil? or !favourite_photo_ids.member?(photo.id)
      self.push favourite_photo_ids: photo.id
      photo.inc :favourites => 1
      true
    else
      false
    end
  end

  protected

  def normalize_phone
    phone = self.phone.gsub(/[^0-9x]/, '').
                       gsub(/\A1/, '')
    # TODO: regex
    if phone.length >= 9
      phone = phone[0..2] + '-' + phone[3..5] + '-' + phone[6..-1]
    end
    self.phone = phone
  end
end