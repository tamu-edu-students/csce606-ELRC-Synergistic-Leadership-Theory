Feature: Invitation
    As a candidate
    So that I can have other people fill in the survey on my leadership style
    I want to send invitations to other people with my unique case number

    Scenario: User finishes survey and creates an invitation
        Given I have logged in with user "1"
        And I have completed the survey as user "1"
        When I create an invitation at the bottom of the response page
		Then the invitation's sharecode should be set to the response's sharecode
		And the invitation's parent_response_id should be set to the response's id
        And I should see a link that can be copied

	Scenario: Generate unique invitation URL
		Given an invitation exists
		Then the invitation should have a unique token
		
    Scenario: User tries to visit an alive invitation link
        Given an invitation exists
        When I visit the invitation link
        And I should see the invitation landing page
        And I should see a button to take the test
        And the invitation should expire

	Scenario: User tries to visit an expired invitation link
		Given an invitation exists
		And the invitation has expired
		When I visit the invitation link
		Then I should be redirected to the not found page
		Then I should see an error message

	Scenario: Logged in user visits the link and claims the invitation
		Given an invitation exists
		And I have logged in with user "1"
		When I visit the invitation link
		Then the invitation is claimed by user "1"
		Then the invitation has a non-null response object
		And the response has the same sharecode as the invitation
		And I click the button to take the test
		Then I should be redirected to the survey edit page

	Scenario: Non-logged in user visits the link and is redirected to external auth provider
		Given I have not logged in
		And an invitation exists
		When I visit the invitation link
		Then I should see a button to take the test

