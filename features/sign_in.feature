Feature: Contestant Sign In

Scenario: Registered contestant can sign in
  Given a registered contestant
  When I am on the homepage
  Then I follow the sign in link
  Then I should be on the sign in page
  And when I enter my details and submit
  Then I should be signed in
  And I should be on my personal home page
