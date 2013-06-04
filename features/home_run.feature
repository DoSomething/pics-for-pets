Feature: Home run
  We need to check the basic flow works.

  Scenario: Show the login form
    When I visit /
    Then the page should show Already have an account?
    When I click on log in
    Then the page should show Not a DoSomething.org member?

  Scenario: Log in
    Given I am on the login form
    When I sign in
    Then the page should show you've logged in successfully
    Then the page should show Maryland

  @javascript
  Scenario: Submit flow
    Given I am logged in
    When I visit /submit
    Then the page should show TELL US ABOUT YOUR ANIMAL

    When I fill out the image field

    Then element .form-submit should show Top text
    Then element .form-submit should show Bottom text

    When I fill in #post_top_text with Ruby text
    Then element #upload-preview should show Ruby text

    When I fill out the rest of the form
    Then the page should redirect matching \d+
    Then element .post should show 
