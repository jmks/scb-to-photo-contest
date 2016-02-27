Given(/^there is no current contest$/) do
end

Given(/^there are past contests$/) do
  FactoryGirl.create_list(:past_contest, 2)
end

When(/^I view the home page$/) do
  visit root_path
end

Then(/^I see no contests listed$/) do
  expect(page).to have_selector "#no-contest-message"
  expect(page).not_to have_selector "#past-contests"
end

Then(/^I see the past contests$/) do
  expect(page).to have_selector "#past-contests"
end

Given(/^there is a current contest$/) do
  FactoryGirl.create :contest
end

Then(/^I see the current contest$/) do
  expect(page).to have_selector "#current-contest-actions"
end
