Feature: Data Submission
    Verify data anylysis

    Scenario: Analysis displays correct values
        Given I have completed the survey with valid inputs
        When I try to submit the form
        Then the analysis results displays the correct values

    Scenario: Analysis displays tetrahedron
        Given I have completed the survey with valid inputs
        When I try to submit the form
        Then the analysis results displays my leadership style