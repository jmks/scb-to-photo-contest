require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt
  
  # user info
  field :email
  validates_confirmation_of :email
  validates :email, presence: true, uniqueness: true,
                 format: { with:    /\A.+@(.+\.)+\w{2,4}\Z/, 
                           message: "%{value} is not a valid email" }

  field :first_name
  validates :first_name, presence: true

  field :last_name
  validates :last_name, presence: true

  # phone is optional
  field :phone

  # admin
  field :password_hash
  validates :password_hash, presence: true

  field :password_salt
  validates :password_salt, presence: true

  #before_save :encrypt_password
  
  #validates :password, confirmation: true, 
  #                     format: { with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/, 
  #                               message: "minimum 6 characters with atleast 1 number" }

  def self.get_salt
    BCrypt::Engine.generate_salt
  end

  def self.encrypt_password password, salt
    BCrypt::Engine.hash_secret(password, salt)
  end

  # TODO: add to before_save hook to check for wrong
  # params are rename them as you want
  # then can allow validates_confirmation_of :password as well
  def validate_password
    if self[:password]
      unless /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/ =~ self.password
        self.errors.add :password, 'must be 6 characters long with at least 1 number.'
      end
    else
      self.errors.add :password, 'must be present.'
    end
  end
end