Given(/^a past contest$/) do
  @contest = FactoryGirl.create :past_contest
end

When(/^I am on the admin page$/) do
  visit admin_root_path
end

When(/^I click on the create contest button$/) do
  find("#new-contest").click
end

Then(/^I should be on the new contest page$/) do
  expect(page.current_path).to eql new_contest_path
end

When(/^I fill in contest details$/) do
  @new_contest = FactoryGirl.build :contest

  within "#new_contest" do
    fill_in "contest_open_date", with: @new_contest.open_date
    fill_in "contest_close_date", with: @new_contest.close_date
    fill_in "contest_judge_open_date", with: @new_contest.judge_open_date
    fill_in "contest_judge_close_date", with: @new_contest.judge_close_date
    fill_in "contest_voting_close_date", with: @new_contest.voting_close_date
    fill_in "contest_votes_per_day", with: @new_contest.votes_per_day
    fill_in "contest_entries_per_contestant", with: @new_contest.entries_per_contestant
    fill_in "contest_nominees_per_category", with: @new_contest.nominees_per_category
  end

  click_button "Create Contest"
end

Then(/^a new contest is created$/) do
  comparable_attributes = [
    :open_date, :close_date, :judge_open_date,
    :judge_close_date, :voting_close_date, :votes_per_day,
    :entries_per_contestant, :nominees_per_category
  ].map(&:to_s)

  comparable_attributes.each do |attr|
    expected = @new_contest[attr]
    actual   = Contest.last[attr]

    if expected.is_a? Time
      expect(actual).to be_within(1.second).of expected
    else
      expect(actual).to eql expected
    end
  end
end

Then(/^I should not see the create contest button$/) do
  expect(page).not_to have_selector "#new-contest"
end
