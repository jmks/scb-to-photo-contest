class Email
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :email
  field :message

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,   presence: true, allow_blank: false,
                      format: { with: VALID_EMAIL_REGEX }
  validates :message, presence: true, allow_blank: false                   
end