require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt
  
  # user info
  field :id, :as => :email
  validates :id, presence: true, uniqueness: true,
                 format: { with: /\A.+@(.+\.)+\w{2,4}\Z/, message: "%{value} is not a valid email" }

  field :first_name
  validates :first_name, presence: true

  field :last_name
  validates :last_name, presence: true

  # phone is optional
  field :phone

  # admin
  field :password_hash
  #validates :password_hash, presence: false

  field :password_salt
  #validates :password_salt, presence: false

  #before_save :encrypt_password
  
  #validates :password, confirmation: true, 
  #                     format: {with: /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/, message: "minimum 6 characters with atleast 1 number"}

  private

  def encrypt_password
    raise NotImplementedError
  end
end