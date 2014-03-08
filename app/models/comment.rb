class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :photo, inverse_of: :comments

  field :name
  validates :name, presence: true
  
  field :text
  validates :text, presence: true

  field :reported, type: Boolean, default: false
end