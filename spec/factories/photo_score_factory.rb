FactoryGirl.define do
  factory :photo_score do
    technical_excellence { (1..10).to_a.sample }
    subject_matter       { (1..10).to_a.sample }
    composition          { (1..10).to_a.sample }
    overall_impact       { (1..20).to_a.sample }

    association :photo
    association :judge
  end
end
