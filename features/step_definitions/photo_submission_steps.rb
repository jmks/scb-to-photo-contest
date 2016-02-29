Given(/^a running contest$/) do
  FactoryGirl.create :contest
end

Given(/^I am a registered user and signed in$/) do
  @current_contestant = FactoryGirl.create :contestant
  log_in_as @current_contestant
end

Given(/^I have entered a photo's details$/) do
  step "I am a registered user and signed in"
  @photo = FactoryGirl.create :photo, owner: @current_contestant
end

Given(/^I have uploaded a photo$/) do
  step "I am a registered user and signed in"
  @photo = FactoryGirl.create :photo, owner: @current_contestant, original_url: "http://exapmle.com"
end

Given(/^I am on the homepage$/) do
  visit root_path
end

When(/^I try to submit a photo$/) do
  visit new_photo_path
end

Then(/^I am sent to the signup page$/) do
  page.current_path.should eql new_contestant_registration_path
end

Then(/^I am on the photo details page$/) do
  page.current_path.should eql new_photo_path
end

When(/^I submit the photo details$/) do
  @photo = FactoryGirl.build :photo, owner: @current_contestant

  within '#new-photo-form' do
    fill_in 'Title',       with: @photo.title
    select @photo.category.capitalize, from: 'photo[category]'
    fill_in 'Description', with: @photo.description
  end

  click_button 'Submit Details'
end

Then(/^I have started a submission$/) do
  photo = Photo.last

  expect(photo.owner).to eql @current_contestant
  expect(photo.title).to eql @photo.title
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

Given(/^I am on the upload photo page$/) do
  visit new_photo_entry_path(photo_id: @photo.id)
end

When(/^I upload a photo$/) do
  pending
  filepath = Rails.root.join('features').join('images').join('chipmunk.jpg')
  attach_file('file', filepath)

  page.evaluate_script("document.forms[0].submit()")
  #form = find('form#s3-uploader')
  #Capybara::RackTest::Form.new(page.driver, form.native).submit :name => nil
end

Then(/^my photo is uploaded$/) do
  @photo.original_url?.should be true
end

Then(/^I am on the order page$/) do
  page.current_path.should eql order_path
end

Then(/^I see a warning about incomplete submissions$/) do
  page.assert_selector("#alerts", text: "The following entries are incomplete:")
end

When(/^I edit my submission$/) do
  find("a[href$=edit]").click
end

When(/^I go to the confirmation step$/) do
  visit verify_path
end

When(/^I enter a valid confirmation code$/) do
  fill_in @photo.id.to_s, with: '12345678'

  click_button 'Verify Photos'
end

Then(/^my submission is completed$/) do
  visit contestant_index_path

  page.assert_selector("tr[data-id=\"#{@photo.id.to_s}\"]", text: Photo::Registration_Message[:printed])
end
