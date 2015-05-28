FactoryGirl.define do
  factory :contest do
    open_date { 1.day.ago }
    close_date { 6.days.from_now }
    judge_open_date { 1.week.from_now }
    judge_close_date { 2.weeks.from_now }
    voting_close_date { 1.week.from_now }
    votes_per_day 3
    entries_per_contestant 5
    nominees_per_category 2
  end

  factory :past_contest, class: Contest do
    open_date         { 52.weeks.ago }
    close_date        { 51.weeks.ago }
    judge_open_date   { 51.weeks.ago }
    judge_close_date  { 50.weeks.ago }
    voting_close_date { 51.weeks.ago }
    votes_per_day 3
    entries_per_contestant 5
  end
end
