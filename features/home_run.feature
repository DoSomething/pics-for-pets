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
    Then the page should show Maryland

  @javascript
  Scenario: Submit flow
    Given I am logged in
    When I visit /submit
    Then the page should show TELL US ABOUT YOUR ANIMAL

    Then element .form-submit should not show Adopt me because...
    Then element .form-submit should not show Text position

    When I fill out the image field

    Then element .form-submit should show Adopt me because...
    Then element .form-submit should show Text position

    When I fill in #post_meme_text with Ruby text
    Then element #upload-preview should show Ruby text

    When I fill out the rest of the form and submit
    Then the page should redirect matching \d+
    Then element .post should show Spot
