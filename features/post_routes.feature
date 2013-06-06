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

  Scenario: Filters
    Given I am logged in
    Given there is a post

    When I visit /cats
    Then the element .post-list should show Spot the kitten

    When I visit /cats-PA
    Then the element .post-list should show Spot the kitten

    When I visit /PA
    Then the element .post-list should show Spot the kitten

    When I visit /dogs-PA
    Then the element .post-list should show Oh, no!

    When I visit /dogs
    Then the element .post-list should show Oh, no!

    When I visit /others-PA
    Then the element .post-list should show Oh, no!

    When I visit /others
    Then the element .post-list should show Oh, no!