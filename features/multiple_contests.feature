Feature: Host multiple contests
    In order run multiple contests
    As an administrator
    I want create multiple contests

  Scenario: create new contests
    Given I am on the admin page
    And there is no current contest
    Then I can create a new contest

  @current_contest
  Scenario: can not create a contest with current
    Given I am on the admin page
    And there is a current contest
    Then I see no option to create a contest

  @past_contest
  Scenario: create new contest after current is complete
    Given I am on the admin page
    And there is a past contest
    Then I can create a new contest
