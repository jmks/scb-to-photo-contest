Then(/^I can see the create contest button$/) do
  expect(page).to have_selector "#new-contest"
end
