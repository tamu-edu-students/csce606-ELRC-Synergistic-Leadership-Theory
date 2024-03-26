Feature: Survey Profile Creation upon successful OAuth login
    Verify survey profile


    Scenario: User logs in and creates survey profile
    Given that I am on the homepage
    And I try to login
    And I have never created a survey profile
    Then I am redirected to the create survey profile page
    And I fill in my district name and campus name and click create
    Then I am redirected to the home page
    

    Scenario: User that has already created survey profile logs in
    Given that I am on the homepage
    And I try to login
    And I have created a survey profile
    Then I am redirected to the homepage 
    And I am greeted with a welcome message
    

