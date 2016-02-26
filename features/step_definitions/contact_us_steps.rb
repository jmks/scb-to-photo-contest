When /^I submit the contact form$/ do
  visit root_path
  fill_out_contact_form
  submit_contact_form
end

Then /^I should see the message has been sent$/ do
  contact_email_was_sent
  see_confirmation_message
end

def fill_out_contact_form
  within "#contact-form" do
    fill_in "message", with: "Howdy Ho!"
    fill_in "email", with: "mrhankey@example.com"
  end
end

def submit_contact_form
  click_button "Send"
end

def contact_email_was_sent
  email = ActionMailer::Base.deliveries.first

  expect(email.body).to include "Howdy Ho!"
  expect(email.body).to include "mrhankey@example.com"
end

def see_confirmation_message
  expect(page.body).to include "Thank you contacting us"
end
