FactoryGirl.define do
  factory :photo do
    sequence :title do |n|
      "Photo title #{n}"
    end
    category { Photo::CATEGORIES.sample }
    association :owner, factory: :contestant
    association :contest, factory: :contest
    tags %w{tag1 tag2 tag3 tag4}.sample(2)
  end
end
