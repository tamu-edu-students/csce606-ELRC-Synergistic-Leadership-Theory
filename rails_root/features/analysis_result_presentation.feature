Feature: Present Analysis Results
    Present the results of the leadership survey

    Scenario: Invalid survey inputs
        Given questions exist
        And I have completed the survey with invalid inputs
        When I try to submit the form
        Then I do not get redirected to the analysis presentation page

    Scenario: Valid survey inputs
        Given questions exist
        And I have completed the survey with valid inputs
        When I try to submit the form
        Then I do get redirected to the analysis presentation page