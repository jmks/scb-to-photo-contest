Feature: Home page

Scenario: Contact the organizers
  When I submit the contact form
  Then I should see the message has been sent
