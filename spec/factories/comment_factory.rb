FactoryGirl.define do
  factory :comment do
    sequence :name do |n|
      "user#{n}"
    end

    text { ["Super duper!", "Fantastic!", "Lamesauce!!1!"].sample }
    reported { false }
    association :photo, factory: :photo
  end
end
