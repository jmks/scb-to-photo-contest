FactoryGirl.define do
  factory :nominee do
    association :judge
    association :photo

    category { Photo::CATEGORIES.sample }
  end
end
