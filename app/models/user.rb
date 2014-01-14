class User
  include Mongoid::Document
  
  # user info
  field :id, :as => :email
  field :first_name
  field :last_name
  # phone is optional
  field :phone

  # admin
  field :password_hash
  field :salt

  # indexes
  # _id/email index not required as it must be unique
end