require 'spec_helper'

describe 'PhotoScore' do 
  before :all do 
    SCORES_CREATED = 3
  end
  
  before :each do 
    @judge = create(:judge)
    
    SCORES_CREATED.times do
      score = build(:photo_score, judge_id: @judge.id)
      score.judge_id = @judge.id
      score.save!
    end

    # this is a weird dependancy
    Photo.all.each do |photo|
      @judge.shortlist_photo photo
    end
    
    @judge.save
  end

  describe 'self.get_scorecard' do 
    it "returns all photo scores by a judge by photo" do 
      scorecard = PhotoScore.get_scorecard @judge

      expected_scorecard_ids = Hash[ PhotoScore.all.map{ |ps| [ ps.photo_id, ps.id ] } ]
      
      # same keys
      expect(scorecard.keys.map(&:id)).to match_array expected_scorecard_ids.keys

      # same values for all keys
      scorecard.keys.each do |photo|
        expect(scorecard[photo].id).to eql expected_scorecard_ids[photo.id]
      end
    end
  end

  describe 'self.photo_scores' do 
    xit "returns hashified photo scores with expected winners applied" do 

    end
  end

  describe '#total_score' do 
    it 'sums up the scores' do 
      photo_score = build :photo_score

      expected_score = photo_score.technical_excellence + photo_score.subject_matter + photo_score.composition + photo_score.overall_impact
      expect(photo_score.total_score).to eql expected_score
    end
  end

  describe '#any_scores?' do 
    it 'is false when all scores are empty' do 
      expect(build(:photo_score_unscored)).to_not be_any_scores
    end

    it 'is true for photos that have at least 1 score' do 
      photo_score = build :photo_score_unscored
      photo_score.technical_excellence = 10

      expect(photo_score).to be_any_scores
    end
  end
end