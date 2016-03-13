Given /^a registered contestant$/ do
  @current_contestant = registered_contestant
end

Then /^I follow the sign in link$/ do
  find("a.signin-link").click
end

Then /^I should be on the sign in page$/ do
  page.current_path.should eql new_contestant_session_path
end

And /^when I enter my details and submit$/ do
  fill_in 'contestant[email]', with: @current_contestant.email
  fill_in 'contestant[password]', with: @current_contestant.password

  click_button "Sign in"
end

Then /^I should be signed in$/ do
  page.should have_selector '#alerts .alert.alert-success'
  within('#alerts .alert.alert-success') { page.should have_content('Signed in successfully') }
end
