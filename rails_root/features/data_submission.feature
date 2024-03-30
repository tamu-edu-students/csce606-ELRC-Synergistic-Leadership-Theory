Feature: Data Submission
    Verify data anylysis

    Scenario: Analysis displays correct values
        Given I have completed the survey with valid inputs
        When I try to submit the form
        Then the analysis results displays the correct values

    Scenario: Analysis displays tetrahedron
        Given I have created survey response
        When I go to survey result page 1
        Then the analysis results displays my leadership style

    Scenario: See Next button
        Given I am on the site
        And I try to login
        And I have created a survey profile previously
        When I visit survey responses page
        And I click New survey response
        Then I should be on the survey path
        And I see Next button

    Scenario: See Save button
        Given I am on the site
        And I try to login
        And I have created a survey profile previously
        When I visit survey responses page
        And I click New survey response
        Then I should be on the survey path
        And I see Previous button

    Scenario: Click submit button
        Given I am on the site
        And I try to login
        And I have created a survey profile previously
        When I visit survey responses page
        And I click New survey response
        And I click Submit button
        Then I should be on the survey response page 1

    