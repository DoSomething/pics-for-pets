Feature: Test pages
  We need to check basic routes

  Scenario: Routes
    Given we visited :index
    Then the page should redirect to :login
