class Nominee
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :judge
  validates  :judge_id, presence: true

  belongs_to :photo
  validates  :photo_id, presence: true

  field :category, type: Symbol
end
