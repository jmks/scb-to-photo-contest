And /^I try to sign up$/ do 
  click_link "SIGN UP"
end

Then /^I am on the sign up page$/ do 
  page.current_path.should eql new_contestant_registration_path
end

When /^I enter my details and submit$/ do 
    %w{first_name last_name public_name email phone password}.each do |field|
        fill_in "contestant[#{field}]", with: @unregistered[field]
    end

    # confirmations
    fill_in 'contestant[password_confirmation]', with: @unregistered[:password]

    click_button "Sign up"
end

Then /^I should be signed up$/ do 
    page.should have_selector '#alerts .alert.alert-success'
    within('#alerts .alert.alert-success') { page.should have_content('signed up successfully') }
end

Then /^I should be on my personal home page$/ do 
    page.current_path.should eql contestant_index_path
end

Given /^I am on a photo page$/ do 
    visit photo_path(@photo.id)
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

