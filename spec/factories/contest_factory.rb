FactoryGirl.define do 
  factory :contest do 

    factory :configured_contest do 
      open_date  { 1.days.ago }
      close_date { 6.days.from_now }
      entries_per_contestant 5

      factory :running_contest do 
        state :open
      end
    end
  end
end