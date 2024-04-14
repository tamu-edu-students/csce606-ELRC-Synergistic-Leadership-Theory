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

	Scenario: Non-logged in user signs up, returns from external auth provider within 15 minutes and claims the invitation
		Given I have not logged in
		And an invitation exists
		When I visit the invitation link
		Then a session variable named "invitation" should be created
		Then I decide to use the user ID "hkeller80"
		And I have been redirected to the external auth provider
		When I return from the external auth provider 10 minutes later
		Given I have never created a survey profile
		Then I am redirected to the create survey profile page
		Then I fill in my first and last name and district name and campus name and organization role and click create
		Then the invitation is claimed by user "hkeller80"
		Then the invitation has a non-null response object
		And the response has the same sharecode as the invitation
		Then I should be redirected to the survey edit page

	Scenario: Non-logged in user logs in, returns and claims the invitation
		Given I "Gary Chalmers", the "Superintendent" from "Springfield Elementary" in "Town of Springfield" join
		And I am logged in
		Then I log out
		And I am not logged in
		And an invitation exists
		When I visit the invitation link
		And I should see the invitation landing page
		Then a session variable named "invitation" should be created
		Then I decide to log in as "Gary Chalmers"
		And I have been redirected to the external auth provider
		Then I return from the external auth provider 10 minutes later
		Then the invitation is claimed by me
		Then the invitation has a non-null response object
		And the response has the same sharecode as the invitation
		Then I should be redirected to the survey edit page

	Scenario: User tries hard but misses the 15-minute window
		Given I have not logged in
		And an invitation exists
		When I visit the invitation link
		Then a session variable named "invitation" should be created
		Then I decide to use the user ID "mr.bean"
		And I have been redirected to the external auth provider
		When I return from the external auth provider 16 minutes later
		Given I have never created a survey profile
		Then I am redirected to the create survey profile page
		Then I fill in my first and last name and district name and campus name and organization role and click create
		Then the invitation is not claimed by user "mr.bean"

	Scenario: People join and commence an invitation orgy
		Given I "Gary Chalmers", the "Superintendent" from "Springfield Elementary" in "Town of Springfield" join
		And I have completed an originating survey
		And I create an invitation at the bottom of the response page
		And I log out
		Then I "Seymour Skinner", the "Principal" from "Springfield Elementary" in "Town of Springfield" join
		And I visit the invitation link
		And I click the button to take the test
		Then I should be redirected to the survey edit page
		And I have completed the survey
		And I create an invitation at the bottom of the response page
		And I log out
		Then I "Edna Krabappel", the "Teacher" from "Springfield Elementary" in "Town of Springfield" join
		And I visit the invitation link
		And I click the button to take the test
		Then I should be redirected to the survey edit page
		And I have completed the survey
		And I log out
		Then I "Xin Tong", the "Superintendent" from "Team ELRC" in "College Station" join
		And I am on the survey responses page
		Then I search any responses related to this invitation
		Then I should see "3" responses