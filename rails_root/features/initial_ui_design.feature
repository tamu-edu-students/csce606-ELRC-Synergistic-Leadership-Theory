Feature: Initial UI Design
    Verify ui design

Background: Questions and responses exist
    Given the following questions exist:
    | text        | explanation | section  | 
    | Are you ok? | No I am not | 0 |
    | question 2 | explanation 2 | 1 |
    | question 3 | explanation 3 | 2 |
    | question 4 | explanation 4 | 3 |
    | question 5 | I am fine | 4 |

    Given the survey profiles exist:
    |user_id| first_name| last_name| campus_name| district_name|
    | 1 | John |Doe|Campus 1|District 1|
    | 2 | Jane |Doe|Campus 2|District 2|


    Scenario: Verify survey profile page
        Given I am on the site
        When I visit survey profile page
        Then I can see profile form

    Scenario: Verify survey form page
        Given I am on the site
        When I visit survey form page
        Then I can see survey sections

    Scenario: Verify survey qustions
        When I visit survey form page
        Then I can see "Are you ok?"

    Scenario: Verify explanation on survey_responses page
        Given user 1 responses to question "Are you ok?"
        When I am on the survey responses page of user 1
        Then I can see "Are you ok?"
        And I can see "No I am not"
        
