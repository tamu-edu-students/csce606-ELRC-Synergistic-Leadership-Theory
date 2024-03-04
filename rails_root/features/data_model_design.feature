Feature: Establish Project Data Models
    Verify the correctness of the data models

    Scenario: Invalid model attributes
        Given questions exist
        And I have a set of invalid attributes
        When I try to create model instances
        Then the model was not created

    Scenario: Valid model attributes
        Given questions exist
        And I have a set of valid attributes
        When I try to create model instances
        Then the model was created