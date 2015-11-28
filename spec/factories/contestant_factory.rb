FactoryGirl.define do
  factory :contestant do
    sequence :email do |n|
      "valid#{n}@example.com"
    end

    password 'supersecret'
    first_name 'Jenny'
    last_name 'Smith'
    public_name 'jenny from the block'
    phone '5558675309'
  end

  factory :admin, class: Contestant do
    sequence :email do |n|
      "admin#{n}@example.com"
    end

    password "icanhazadmin"
    first_name "Admin"
    sequence :last_name do |n|
      "the #{ActiveSupport::Inflector.ordinalize(n)}"
    end

    sequence :public_name do |n|
      "Admin the #{ActiveSupport::Inflector.ordinalize(n)}"
    end

    admin true
  end
end
