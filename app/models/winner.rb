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
    assigned = Winner.all.map { |w| w.prize }
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
    if ContestRules::REQUIRED_PRIZES.include?(prize)
      unless Winner.where(prize: prize).empty?
        errors.add(:prize, "#{prize} already assigned!")
      end
    else
      unless ContestRules::OPTIONAL_PRIZES.include?(prize)
        errors.add(:prize, "#{prize} not found!")
      end
    end
  end
end