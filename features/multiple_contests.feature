Feature: Host multiple contests
  In order run multiple contests
  As an administrator
  I want create multiple contests

Background:
  Given I am an admin

Scenario: create new contests
  Given there is no current contest
  And I am on the admin page
  Then I can see the create contest button

Scenario: can not create a contest with current
  Given there is a current contest
  And I am on the admin page
  Then I should not see the create contest button

Scenario: create new contest after current is complete
  Given a past contest
  And I am on the admin page
  Then I can see the create contest button
