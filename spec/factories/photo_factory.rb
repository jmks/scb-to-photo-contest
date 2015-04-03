FactoryGirl.define do 
  factory :photo do 
    sequence :title do |n|
      "Photo title #{n}"
    end
    category { Photo::CATEGORIES.sample }
    association :owner, factory: :contestant
    tags %w{tag1 tag2 tag3 tag4}.sample(2)
  end
end