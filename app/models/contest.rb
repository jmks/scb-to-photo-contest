class Contest
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

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
  validate :only_one_open_contest_at_a_time

  field :votes_per_day,          type: Integer, default: 3
  field :entries_per_contestant, type: Integer, default: 5
  field :nominees_per_category,  type: Integer, default: 2

  scope :previous, ->{ where(:close_date.lte => DateTime.current).desc(:close_date) }
  scope :open_contests, ->(open_date, close_date) { any_of({:close_date => open_date..close_date}, {:open_date =>  open_date..close_date}) }

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

  ###
  # Contest state
  ##

  field :aasm_state
  aasm do
    state :configuration, initial: true
    state :running
    state :nominating
    state :scoring
    state :prize_allocation
    state :complete

    event :configured! do
      transitions from: :configuration, to: :running
    end

    event :closed! do
      transitions from: :running, to: :nominating
    end

    event :nominations_completed! do
      transitions to: :scoring
    end

    event :scored! do
      transitions from: :nominating, to: :prize_allocation
    end

    event :prizes_allocated! do
      transitions from: :prize_allocation, to: :complete
    end
  end

  before_create { |contest| contest.configured! }
  after_find :update_state!

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

  def update_state!
    closed! if running? && !open?
    nominations_completed! if judges.map { |judge| judge.nominations_locked_for?(self) }.all?
  end

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

  def only_one_open_contest_at_a_time
    return unless open_date && close_date
    return if Contest.open_contests(open_date, close_date).empty?

    errors.add(:base, "there must not be open contests between the start date and close date")
  end
end
