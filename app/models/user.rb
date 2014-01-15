class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # user info
  field :id, :as => :email
  field :first_name
  field :last_name
  # phone is optional
  field :phone

  # admin
  field :password_hash
  field :password_salt

  # indexes
  # _id/email index defaultly unique and indexed
end