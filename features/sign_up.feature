Feature: Contestant Sign up

Scenario: Unregistered user can sign up
  When I am on the homepage
  And I try to sign up
  Then I am on the sign up page
  And when I enter my details
  Then I am successfully signed up

Scenario: Unregistered users can view photos
Scenario: Unregistered users can not vote nor favourite photos