FactoryGirl.define do 
  factory :photo do 
    title 'Walk in the park'
    category :landscapes
    association :owner, factory: :contestant
  end
end