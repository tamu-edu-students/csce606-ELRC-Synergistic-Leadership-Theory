Feature: Development Environment Setup
    Verify development environment setup

    Scenario: Verify database connection
        Given the application is running
        When I attempt to connect to the database
        Then I should receive a successful connection
