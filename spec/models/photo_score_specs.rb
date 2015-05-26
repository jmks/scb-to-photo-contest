require 'spec_helper'

describe 'PhotoScore' do

  let(:photo_score) { build :photo_score }

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

  describe '#total_score' do
    it "is initially zero" do
      expect(PhotoScore.new.total_score).to be 0
    end

    it 'sums up the scores' do
      expected = PhotoScore::SCORE_CRITERIA.
        map { |score| photo_score.public_send(score) }.
        inject(0, &:+)

      expect(photo_score.total_score).to eql expected
    end
  end
end
