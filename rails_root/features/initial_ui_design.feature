Feature: Initial UI Design
    Verify ui design

    Scenario: Verify survey profile page
        Given I am on the site
        When I visit survey profile page
        Then I can see profile form

    Scenario: Verify survey form page
        Given I am on the site
        When I visit survey form page
        Then I can see survey sections

    Scenario: Verify survey qustions
        Given the following questions exist:
        | text        | explanation | section  | 
        | Are you ok? | explanation 1 | 0 |
        | question 2 | explanation 2 | 1 |
        | question 3 | explanation 3 | 2 |
        | question 4 | explanation 4 | 3 |
        | question 5 | I am fine | 4 |
        When I visit survey form page
        Then I can see "Are you ok?"

        
        
