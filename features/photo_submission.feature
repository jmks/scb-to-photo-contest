Feature: Photo submission process
    In order to enter the contest
    As a registered user
    I want to win great prizes!

@unregistered
Scenario: unregistered users are told to signup
    Given I am on the homepage
    When I try to submit a photo
    Then I am on the signup page

@registered
Scenario: step 1 - users can enter photo details
    Given I am on the homepage
    When I try to submit a photo
    Then I am on the photo details page
    When I fill in the details
    Then I have started a submission

@registered
@photo_details
Scenario: Users can edit their photos
    Given I am the user page
    Then I should see a submission
    When I click to edit the submission
    Then I should be on the details edit page
    When I change the photo details
    Then the details should be changed

@registered
@photo_details
Scenario: step 2 - users can upload a photo


@registered
@photo_uploaded
Scenario: step 3 - users can confirm they printed their photo
    Given I am on the user page
    Then I see a warning about incomplete submissions
    When I edit my submission
    And I go to the confirmation step
    When I enter a valid confirmation code
    Then my submission is completed

@registered
@photo_complete
Scenario: Users see their completed submissions
    When I am on the user page
    Then I see my completed submissions