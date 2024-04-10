Feature: Specific Survey Questions Rendered based on User Role. 
    Verify Survey Profile and Survey Response

    Scenario: User logs in for the first time and takes survey as a principal
        Given that I am on the homepage
        And I try to login
        And I have never created a survey profile
        Then I am redirected to the create survey profile page
        And I fill in my information as a principal
        Then a survey profile is created for me as a principal
        Then I am redirected to the home page
        Then I am logged in as a principal
        When I navigate to the survey page
        Then I should see the survey questions specific to the principal

    Scenario: User logs in for the first time and takes survey as a teacher
        Given that I am on the homepage
        And I try to login
        And I have never created a survey profile
        Then I am redirected to the create survey profile page
        And I fill in my information as a teacher
        Then a survey profile is created for me as a teacher
        Then I am redirected to the home page
        Then I am logged in as a teacher
        When I navigate to the survey page
        Then I should see the survey questions specific to the teacher

    Scenario: User logs in for the first time and takes survey as a superintendent
        Given that I am on the homepage
        And I try to login
        And I have never created a survey profile
        Then I am redirected to the create survey profile page
        And I fill in my information as a superintendent
        Then a survey profile is created for me as a superintendent
        Then I am redirected to the home page
        Then I am logged in as a superintendent
        When I navigate to the survey page
        Then I should see the survey questions specific to the superintendent
