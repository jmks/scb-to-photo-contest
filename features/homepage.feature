Feature: Home page

Scenario: View the home page
  When I am on the homepage
  Then I should be on the homepage

Scenario: Contact the organizers
  When I am on the homepage
  And I fill out the contact form
  And I press "Send"
  Then I should see the message has been sent