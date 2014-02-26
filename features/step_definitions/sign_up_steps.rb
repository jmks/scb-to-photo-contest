Before do 
  @contestant = FactoryGirl.build(:contestant)
end

And /^I try to sign up$/ do 
  visit new_contestant_registration_path
end

Then /^I am on the sign up page$/ do 
  page.should have_content "Sign Up"
end