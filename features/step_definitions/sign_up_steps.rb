Given(/^an unregistered contestant$/) do
  @unregistered_contestant = FactoryGirl.build(:contestant)
  @unregistered_contestant[:password] = "password123"
end

Given(/^a running contest with photos$/) do
  step "a running contest"
  @photos = FactoryGirl.create_list :photo, 3
end

And /^I try to sign up$/ do
  click_link "SIGN UP"
end

Then /^I am on the sign up page$/ do
  page.current_path.should eql new_contestant_registration_path
end

When /^I enter my details and submit$/ do
  %w{first_name last_name public_name email phone password}.each do |field|
    fill_in "contestant[#{field}]", with: @unregistered_contestant[field]
    fill_in "contestant[password_confirmation]", with: @unregistered_contestant[:password] if field == "password"
  end

  click_button "Sign up"
end

Then /^I should be signed up$/ do
  page.should have_selector '#alerts .alert.alert-success'
  within('#alerts .alert.alert-success') { page.should have_content('signed up successfully') }
end

And /^I should be on my personal home page$/ do
  page.current_path.should eql contestant_index_path
end

Given /^I am on a photo's page$/ do
  @photo = FactoryGirl.create(:photo)
  visit photo_path(@photo)
end

Given /^I am on the photos page$/ do
  visit photos_path
end

Then /^I can not leave a comment$/ do
  page.should_not have_selector '#leave-comment-form'
end

Then /^I can see the photos$/ do
  page.should have_selector '#photo-wall .photo'
end
