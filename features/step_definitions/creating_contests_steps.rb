Given(/^a past contest$/) do
  @contest = FactoryGirl.create :past_contest
end

When(/^I am on the admin page$/) do
  visit admin_root_path
end

When(/^I click on the create contest button$/) do
  pending "button does not exist"
  find("#new-contest").click
end

Then(/^I should be on the new contest page$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I fill in contest details$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^a new contest is created$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see the create contest button$/) do
  expect(page).not_to have_selector "#new-contest"
end
