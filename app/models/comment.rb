class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :photo, inverse_of: :comments

  # TODO field :user_id

  field :name
  validates :name, presence: true
  
  field :text
  validates :text, presence: true
end