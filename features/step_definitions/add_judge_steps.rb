Given /^I am an admin$/ do
  @admin = FactoryGirl.create :admin
  log_in_as @admin
end

When /^I submit a new judge$/ do
  visit admin_root_path

  @judge = FactoryGirl.build :judge

  within '#new-judge-form' do
    fill_in "First name",  with: @judge.first_name
    fill_in "Last name",   with: @judge.last_name
    fill_in "Email",       with: @judge.email
  end

  click_button "Add Judge"
end

Then /^I see a new judge was created$/ do
  new_judge_created
  see_new_judge_message
end

Then(/^the judge is notified$/) do
  expect(ActionMailer::Base.deliveries.length).to be >= 1

  email = ActionMailer::Base.deliveries.first
  expect(email.to).to include @judge.email
end

def new_judge_created
  recent_judge = Judge.last

  expect(recent_judge.first_name).to eql @judge.first_name
  expect(recent_judge.last_name).to  eql @judge.last_name
  expect(recent_judge.email).to      eql @judge.email
end

def see_new_judge_message
  page.assert_selector "#alerts", text: "Judge #{@judge.full_name} Successfully Added"
end
