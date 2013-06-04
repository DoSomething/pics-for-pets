Feature: Test pages
  We need to check basic routes

  Scenario: Routes
    When I visit /
    Then the page should redirect to /login
    Then the page should respond with 200

	When I visit /submit
	Then the page should redirect to /login
    Then the page should respond with 200

	When I visit /cats
	Then the page should redirect to /login
    Then the page should respond with 200