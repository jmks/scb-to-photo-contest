class Tag
  include Mongoid::Document

  field :name
  validates :name, presence: true, uniqueness: true

  index({ name: 1 }, { unique: true })

  def self.get_tags
    Tag.all.only(:name).entries.map { |t| t.name }
  end

  def self.add_tags names
    names.each do |name|
      begin
        Tag.find(name: name)
      rescue
        Tag.create(name: name)
      end
    end
  end
end