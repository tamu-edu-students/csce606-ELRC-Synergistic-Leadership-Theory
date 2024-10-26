Feature: Admin Dashboard Access
  I want to see the Admin Dashboard link
  So that I can access administrative functions

  Background:
    Given I am on the homepage
    And I try to login

  Scenario: Principal sees "Admin Dashboard" link and clicks it
    Then I should see "Admin Dashboard" in the header
    When I click on "Admin Dashboard"
    Then I should be on the Admin Dashboard page
