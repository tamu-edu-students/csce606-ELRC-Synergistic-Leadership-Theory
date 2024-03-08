Feature: Query Survey information
    Verify researchers and users can query survey responses with unique case number

    Scenario: 
        Given survey profiles exist
        And survey responses exist
        And I am on the survey responses page
        When I enter a unique case number in the "Query by case number field"
        Then I see a list of survey responses with that case number
    
    Scenario: 
        Given survey profiles exist
        And survey responses exist
        And I am on the survey responses page
        When I enter a unique case number with no linked survey responses in the "Query by case number field"
        Then I don't see a list of survey_responses with that case number
        And a warning is flashed

        