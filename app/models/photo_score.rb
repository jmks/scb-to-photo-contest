class PhotoScore
  include Mongoid::Document
  include Mongoid::Timestamps

  field :photo_id
  validates :photo_id, presence: true

  field :judge_id
  validates :judge_id, presence: true

  field :technical_excellence, type: Integer
  validates :technical_excellence, presence: true, 
                                   numericality: { greater_than_or_equal_to: 0 }, 
                                   numericality: { less_than_or_equal_to: 10 }

  field :subject_matter, type: Integer
  validates :subject_matter, presence: true, 
                             numericality: { greater_than_or_equal_to: 0 }, 
                             numericality: { less_than_or_equal_to: 10 }

  field :composition, type: Integer
  validates :composition, presence: true, 
                          numericality: { greater_than_or_equal_to: 0 }, 
                          numericality: { less_than_or_equal_to: 10 }

  field :overall_impact, type: Integer
  validates :overall_impact, presence: true, 
                             numericality: { greater_than_or_equal_to: 0 }, 
                             numericality: { less_than_or_equal_to: 20 }

  def total_score
    score_fields.inject(0, :+)
  end

  def any_scores?
    score_fields.compact.any?
  end

  def self.get_scores judge
    PhotoScore.where(judge_id: judge.id.to_s).to_a
  end

  def self.get_scorecard judge
    scorecard = {}
    Photo::CATEGORIES.each do |category|
      Judge.shortlist(category).each do |photo|
        score = PhotoScore.where(judge_id: judge.id.to_s, photo_id: photo.id.to_s).first
        scorecard[photo] = score
      end
    end
    scorecard
  end

  private

  def score_fields
    [technical_excellence, subject_matter, composition, overall_impact]
  end
end