Feature: Home run
  We need to check the basic flow works.

  Scenario: Show the login form
    When I visit /
    Then the page should show Not a DoSomething.org member?
    When I click on register
    Then the page should show Already have an account?

  Scenario: Log in
    Given I am on the login form
    When I sign in
    Then the page should show Maryland
