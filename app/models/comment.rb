class Comment
  include Mongoid::Document
  embedded_in :photo
  field :name
  field :comment
end