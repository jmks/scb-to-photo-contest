When(/^I try to submit a photo$/) do
  # the view depends on contest "state" ie open or closed
  #find("a[href*=photo/new]").click

  visit new_photo_path
end

Then(/^I am on the signup page$/) do
  page.current_path.should eql new_contestant_registration_path
end

Then(/^I am on the photo details page$/) do
  page.current_path.should eql new_photo_path
end

When(/^I fill in the details$/) do
  @photo = FactoryGirl.build :photo, owner: @current_contestant

  within '#new-photo-form' do
    fill_in 'Title',       with: @photo.title
    select @photo.category.capitalize, from: 'photo[category]'
    fill_in 'Description', with: @photo.description
  end

  click_button 'Submit Details'
end

Then(/^I have started a submission$/) do
  Photo.count.should eql 1
  Photo.first.owner.should eql @current_contestant
  # matching exact photos is difficult with various fields
  Photo.first.title.should eql @photo.title
end

Given(/^I am on the user page$/) do
  visit contestant_index_path
end

Then(/^I should see a submission$/) do
  expect(page).to have_selector("tr[data-id]", count: 1)
end

When(/^I click to edit the submission$/) do
  find("a[href*=edit]").click
end

Then(/^I should be on the details edit page$/) do
  page.current_path.should eql edit_photo_path(@photo)
end

When(/^I change the photo details$/) do
  within '#edit-photo-form' do 
    fill_in "Description", with: "A new bolder description"
  end

  click_button 'Submit Details'
end

Then(/^the details should be changed$/) do
  Photo.first.description.should_not eql @photo.description
end

Then(/^I see a warning about incomplete submissions$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I edit my submission$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I go to the confirmation step$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I enter a valid confirmation code$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^my submission is completed$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I see my completed submissions$/) do
  pending # express the regexp above with the code you wish you had
end
