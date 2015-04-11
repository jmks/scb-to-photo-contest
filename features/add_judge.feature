Feature: Admin can add judge

@admin
Scenario: Add judge
  When I am on the admin page
  And I enter new judge details
  Then a new judge is created
  And the judge is notified
  And I see a confirmation message