class Email
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :email
  
  field :message
end