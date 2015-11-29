Feature: creating contests
    In order run multiple contests
    As an administrator
    I want to create contests

  Scenario: setup a contest
    When I am on the admin page
    And I click on the create contest button
    Then I should be on the new contest page
    When I fill in contest details
    Then a new contest is created
    And I am on the admin page

  @current_contest
  Scenario: can not create a contest with a current contest
    When I am on the admin page
    Then I should not see the create contest button

  @past_contest
  Scenario: create contest with a past contest
    When I am on the admin page
    And I click on the create contest button
    Then I should be on the new contest page
    And I fill in contest details
    Then a new contest is created
