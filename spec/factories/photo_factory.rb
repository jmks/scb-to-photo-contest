FactoryGirl.define do 
  factory :photo do 
    sequence :title do |n|
      "Photo title #{n}"
    end
    category { Photo::CATEGORIES.sample }
    association :owner, factory: :contestant
  end
end