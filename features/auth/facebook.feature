@omniauth
Feature: Login using Facebook Connect
  As a Facebook User
  I want to authenticated to Seamoo
  So I can use Seamoo service

  Scenario: Authorize using Facebook Account
    Given I am recognized as facebook user "Seamoo Test"
    When I go to the secured home index page
    And I follow "Facebook"
    Then I should be on the secured home index page
    And I should see link "Seamoo Test"
    And a user should exist with display_name: "Seamoo Test", email: "seamoo.test@fbmail.com"

  Scenario: Relogin using Facebook Account
    Given I am recognized as facebook user "Seamoo Test"
    And a user exists with display_name: "Seamoo Test", email: "seamoo.test@fbmail.com"
    And an authorization exists with provider: "facebook", uid: "seamoo.test", user: the user
    When I go to the secured home index page
    And I follow "Facebook"
    And I should see link "Seamoo Test"
    And I should see "Welcome back, Seamoo Test"


