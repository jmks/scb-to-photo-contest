FactoryGirl.define do 
  factory :winner do 
    prize       ContestRules::REQUIRED_PRIZES.sample
    category    Photo::CATEGORIES.sample
    association :photo, factory: :photo
  end
end