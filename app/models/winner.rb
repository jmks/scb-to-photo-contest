class Winner
  include Mongoid::Document

  field :category
  validates :category, presence: true

  field :prize
  validates :prize, presence: true
  validate :assignment_validation

  belongs_to :photo, class_name: 'Photo', inverse_of: nil
  validates :photo, presence: true

  def self.assignments_remaining?
    assigned = Winner.all.map &:prize
    (ContestRules::REQUIRED_PRIZES - assigned).any?
  end

  def self.assignments_remaining
    ContestRules::REQUIRED_PRIZES - Winner.all.map { |w| w.prize }
  end

  def self.assignments_complete?
    !assignments_remaining?
  end

  def prize_description
    ContestRules::PRIZE_DESCRIPTIONS[prize]
  end

  def self.winners_by_award
    Hash[Winner.all.map { |win| [win.prize, win.photo] }]
  end

  private

  def assignment_validation
    unless prize_required? or prize_optional?
      errors.add(:prize, "#{prize} not found!")
    end

    if prize_required? and prize_assigned?
      errors.add(:prize, "#{prize} already assigned!")
    end
  end

  def prize_required?
    ContestRules::REQUIRED_PRIZES.include?(prize)
  end

  def prize_assigned?
    Winner.where(prize: prize).exists?
  end

  def prize_optional?
    ContestRules::OPTIONAL_PRIZES.include?(prize)
  end
end