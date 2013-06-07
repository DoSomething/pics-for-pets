Feature: Home run
  We need to check the basic flow works.

  Scenario: Show the login form
    When I visit /
    Then the page should show Already have an account?alskdfj
    When I click on log in
    Then the page should show Not a DoSomething.org member?

  Scenario: Log in
    Given I am on the login form
    When I sign in
    Then the page should show Maryland
