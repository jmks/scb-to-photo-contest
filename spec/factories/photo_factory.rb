FactoryGirl.define do 
  factory :photo do 
    title 'Walk in the park'
    category { Photo::CATEGORIES.sample }
    association :owner, factory: :contestant
  end
end