Feature: Theory Exploration
    Confirm about page renders successfully

    Scenario: Verify about page rendering
        Given I am on the site
        When I visit about page
        Then I can read about theory information
