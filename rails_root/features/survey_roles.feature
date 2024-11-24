Feature: Survey profile roles dropdown
  As a user
  I want to see all available roles in the dropdown
  So that I can select the correct role for my profile

  Background:
    Given I am on the survey profile form page

  Scenario: Verify all roles are displayed in the dropdown
    Then the following roles should be available in the "Role" dropdown:
      | Department Head |
      | Dean            |
      | Provost         |
      | President       |
      | Principal       |
      | Superintendent  |
      | Teacher_Leader  |
      | Supervisor      |
      | Supervisee      |


  Scenario: Select and save a role
    When I select "Dean" from the "Role" dropdown
    And I fill in "First Name" with "John"
    And I fill in "Last Name" with "Doe"
    And I fill in "Campus Name" with "Campus 1"
    And I fill in "District Name" with "District A"
    And I click the "Submit" button
    Then the survey profile should be saved with the role "Dean"
