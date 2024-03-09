Feature: Invitation
    As a candidate
    So that I can have other people fill in the survey on my leadership style
    I want to send invitations to other people with my unique case number

    Scenario: User finishes survey and creates an invitation
        Given I have completed the survey
        When I create an invitation at the bottom of the response page
        Then I should see a link that can be copied

    Scenario: Invited user visits the link
        Given an invitation link exists
        When I visit the invitation link
        Then I should see the invitation landing page
        And I should see a button to take the test
        And the invitation record's visited field should be set to true