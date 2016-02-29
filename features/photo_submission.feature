Feature: Photo submission process
    In order to enter the contest
    As a registered user
    I want to win great prizes!

Background:
  Given a running contest

Scenario: unregistered users are told to signup
    When I try to submit a photo
    Then I am sent to the signup page

Scenario: Step 1 - users can enter photo details
    Given I am a registered user and signed in
    When I try to submit a photo
    Then I am on the photo details page
    When I submit the photo details
    Then I have started a submission

Scenario: Users can edit their photos
    Given I have entered a photo's details
    And I am on the user page
    When I click to edit the submission
    Then I should be on the details edit page
    When I change the photo details
    Then the details should be changed

@photo_upload
Scenario: Step 2 - users can upload a photo
    Given I have entered a photo's details
    Given I am on the upload photo page
    When I upload a photo
    Then my photo is uploaded
    And I am on the order page

Scenario: step 3 - users can confirm they printed their photo
    Given I have uploaded a photo
    And I am on the user page
    Then I see a warning about incomplete submissions
    When I edit my submission
    And I go to the confirmation step
    When I enter a valid confirmation code
    Then my submission is completed

Scenario: Users can see their submissions
  Given I have entered a photo's details
  When I am on the user page
  Then I should see a submission
