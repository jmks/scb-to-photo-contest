FactoryGirl.define do
    sequence :email do |n|
        "iam#{n}@thelaw.com"
    end

  factory :judge do
    first_name 'Judge'
    last_name  'Dredd'
    password   'djjazzyjeff'
    email
  end
end
