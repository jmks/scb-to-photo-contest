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

  def self.photo_scores
    photo_scores = []
    judge_names_by_id = Hash[Judge.completed_scoring.map { |j| [j.id.to_s, j.full_name] }]

    Judge.shortlist_by_category.each_pair do |category, photos|
      photos.each do |photo|
        photo_score = {}

        photo_score[:thumbnail_url] = photo.thumbnail_xs_url
        photo_score[:title]         = photo.title
        photo_score[:photographer]  = photo.owner.full_name
        photo_score[:category]      = category.to_s.capitalize

        photo_score[:scores] = PhotoScore.where(photo_id: photo.id.to_s).in(judge_id: judge_names_by_id.keys).to_a.map do |photoscore|
          {
            judge:       judge_names_by_id[photoscore.judge_id],
            total_score: photoscore.total_score,
            
            technical_excellence: photoscore.technical_excellence,
            composition:          photoscore.composition,
            subject_matter:       photoscore.subject_matter,
            overall_impact:       photoscore.overall_impact
          }
        end

        photo_score[:total_score] = photo_score[:scores].map { |ps| ps[:total_score] }.sum

        photo_scores << photo_score
      end
    end
    
    if photo_scores.empty?
      nil
    else
      ContestRules.apply_winners(photo_scores.sort { |a, b| b[:total_score] <=> a[:total_score] })
    end
  end

  private

  def score_fields
    [technical_excellence, subject_matter, composition, overall_impact]
  end
end