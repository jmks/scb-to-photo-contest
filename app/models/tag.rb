class Tag
  include Mongoid::Document

  field :name
  validates :name, presence: true, uniqueness: true

  index({ name: 1 }, { unique: true })

  def self.get_tags
    Tag.all.map &:name
  end

  def self.add_tags names
    names.each do |name|
      Tag.create(name: name) unless Tag.where(name: name).exists?
    end
  end
end