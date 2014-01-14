class Contestant < User

  has_many :entries,    :class_name => "Photo", :inverse_of => :entry_photos
  has_many :favourites, :class_name => "Photo", :inverse_of => :favourite_photos

  belongs_to :photo

  def admin?
    false
  end
end