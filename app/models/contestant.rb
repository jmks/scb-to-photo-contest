class Contestant < User

  has_many :entries, :class_name => "Photo", :inverse_of => :entry_photos
  has_and_belongs_to_many :favourites, :class_name => "Photo", :inverse_of => :favourite_photos

  def admin?
    false
  end
end