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
        And I can see survey questions
