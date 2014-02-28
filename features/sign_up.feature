Feature: Contestant Sign up

@unregistered
Scenario: Unregistered user can sign up
  When I am on the homepage
  And I try to sign up
  Then I am on the sign up page
  When I enter my details and submit
  Then I should be signed up
  And I should be on my personal home page

Scenario: Unregistered users can view photos
Scenario: Unregistered users can not vote nor favourite photos