Feature: Viewing contests

Scenario: No current or past contests
Given there is no current contest
When I view the home page
Then I see no contests listed

Scenario: No current contest with past contests
Given there is no current contest
But there are past contests
When I view the home page
Then I see the past contests

Scenario: A current contest
Given there is a current contest
When I view the home page
Then I see the current contest
