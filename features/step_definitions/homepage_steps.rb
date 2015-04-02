When /I am on the homepage/ do 
  visit root_path
end

Then /I should be on the homepage/ do
  page.current_path.should eql root_path
end

Then /I fill out the contact form/ do
  within "#contact-form" do 
    fill_in "message", with: "Howdy Ho!"
    fill_in "email", with: "mrhankey@example.com"
  end
end

When(/^I press "(.*?)"$/) do |arg|
  click_button arg
end

Then(/^I should see the message has been sent$/) do
  email = ActionMailer::Base.deliveries.first
  
  email.body.should include "Howdy Ho!"
  email.body.should include "mrhankey@example.com"
end