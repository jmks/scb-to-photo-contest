class Contest
  include Mongoid::Document

  has_many :photos
  has_and_belongs_to_many :judges

  field :open_date, type: DateTime
  validates :open_date, presence: true

  field :close_date, type: DateTime
  validates :close_date, presence: true

  field :judge_open_date, type: DateTime
  validates :judge_open_date, presence: true

  field :judge_close_date, type: DateTime
  validates :judge_close_date, presence: true

  field :voting_close_date, type: DateTime
  validates :voting_close_date, presence: true

  validate :dates_validation

  field :votes_per_day,          type: Integer, default: 3
  field :entries_per_contestant, type: Integer, default: 5
  field :nominees_per_category,  type: Integer, default: 2

  scope :previous, ->{ where(:close_date.lte => DateTime.current).desc(:close_date) }

  def self.any?
    now = DateTime.current

    Contest.
      where(:open_date.lte => now).
      where(:close_date.gte => now).
      any?
  end

  def self.pending?
    Contest.
      where(:open_date.gte => DateTime.current).
      any?
  end

  def self.current
    now = DateTime.current

    Contest.
      where(:open_date.lte => now).
      where(:close_date.gte => now).
      first
  end

  # TODO: replace open?, judging?, and voting? with status enum after upgrading to rails 4.1

  def open?
    (open_date..close_date).cover? DateTime.current
  end

  def judging?
    (judge_open_date..judge_close_date).cover? DateTime.current
  end

  def voting?
    (open_date..voting_close_date).cover? DateTime.current
  end

  # TODO categories as configuration
  def categories
    Photo::CATEGORIES
  end

  private

  # validates that open dates must occur before their respective close dates
  def dates_validation
    [
      [:open_date, :close_date],
      [:judge_open_date, :judge_close_date],
      [:open_date, :voting_close_date]
    ].each do |start, finish|
      next unless public_send(start) && public_send(finish)

      unless public_send(start) <= public_send(finish)
        errors.add(start, "must occur before #{finish}")
      end
    end
  end
end
