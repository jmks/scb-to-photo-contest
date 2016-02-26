Feature: Admin can add judge

Scenario: Add judge
  Given I am an admin
  When I submit a new judge
  Then I see a new judge was created
  And the judge is notified
