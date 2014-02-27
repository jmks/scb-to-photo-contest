FactoryGirl.define do 
  factory :contestant do 
    sequence :email do |n|
      "valid#{n}@example.com"
    end
    password 'supersecret'
    first_name 'Jenny'
    last_name 'Smith'
    public_name 'For a good time call'
    phone '5558675309'
  end
end