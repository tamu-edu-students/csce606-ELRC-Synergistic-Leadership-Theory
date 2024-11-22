Feature: Admin Dashboard Access
  As an admin user,
  I want to see the Admin Dashboard link
  So that I can access administrative functions

  Scenario: Admin logs in successfully
    Given I visit the home page
    When I try to login
    Then I should not see the admin dashboard