When(/^I am on the admin page$/) do
  visit admin_root_path
end

When(/^I enter new judge details$/) do
  @judge = FactoryGirl.build :judge

  within '#new-judge-form' do
    fill_in "First name",  with: @judge.first_name
    fill_in "Last name",   with: @judge.last_name
    fill_in "Email",       with: @judge.email
  end

  click_button "Add Judge"
end

Then(/^a new judge is created$/) do
  recent_judge = Judge.last

  expect(recent_judge.first_name).to eql @judge.first_name
  expect(recent_judge.last_name).to  eql @judge.last_name
  expect(recent_judge.email).to      eql @judge.email
end

Then(/^the judge is notified$/) do
  expect(ActionMailer::Base.deliveries.length).to be >= 1

  email = ActionMailer::Base.deliveries.first
  expect(email.to).to include @judge.email
end

Then(/^I see a confirmation message$/) do
  page.assert_selector "#alerts", text: "Judge #{@judge.full_name} Successfully Added"
end