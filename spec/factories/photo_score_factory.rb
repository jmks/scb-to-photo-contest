FactoryGirl.define do 
  factory :photo_score do 
    technical_excellence { (1..10).to_a.sample }
    subject_matter       { (1..10).to_a.sample }
    composition          { (1..10).to_a.sample }
    overall_impact       { (1..10).to_a.sample }

    # temporary values
    judge_id { 1 }
    photo_id { 1 }

    after(:build) do |photo_score, evaluator|
      judge = Judge.find(judge_id: evaluator.judge_id) || create(:judge)
      photo = Photo.find(photo_id: evaluator.photo_id) || create(:photo)

      photo_score.judge_id = judge.id
      photo_score.photo_id = photo.id
    end

    factory :photo_score_unscored do 
      technical_excellence nil
      subject_matter       nil
      composition          nil
      overall_impact       nil
    end
  end
end