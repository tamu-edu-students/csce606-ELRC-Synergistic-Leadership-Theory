Feature: Reworked Project Data Models
    Verify the correctness of the data models

    Scenario: Invalid model attributes
        Given I have an invalid set of attributes for all models
        When I try to create model instances
        | model_name     |
        | SurveyQuestion |
        | SurveyProfile  |
        | SurveyResponse |
        | SurveyAnswer   |
        Then the models were not created

    Scenario: Valid model attributes
        Given I have an valid set of attributes for all models
        When I try to create model instances
        | model_name     |
        | SurveyQuestion |
        | SurveyProfile  |
        | SurveyResponse |
        | SurveyAnswer   |
        Then the models were created