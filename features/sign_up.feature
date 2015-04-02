Feature: Unregistered users actions

@unregistered
Scenario: Unregistered user can sign up
  When I am on the homepage
  And I try to sign up
  Then I am on the sign up page
  When I enter my details and submit
  Then I should be signed up
  And I should be on my personal home page

@photos
Scenario: Unregistered users can view photos
    Given I am on the photos page
    Then I can see the photos

@photo
Scenario: Unregistered users can not leave comments
    Given I am on a photo page
    Then I can not leave a comment