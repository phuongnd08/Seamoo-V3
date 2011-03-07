Feature: Login using Google Federated Login Service
  As a Google User
  I want to authenticated to Seamoo
  So I can use Seamoo service

  @omniauth
  Scenario: Authorize using Google Account
    Given I am recognized as open id user "Seamoo Test" at "Google"
    When I go to the secured home index page
    And I follow "Google"
    Then I should be on the secured home index page
    And I should see "Hello, Seamoo Test"
    And a user should exist with display_name: "Seamoo Test", email: "seamoo.test@google.com"
