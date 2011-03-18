Feature: Login using Facebook Connect
  As a Facebook User
  I want to authenticated to Seamoo
  So I can use Seamoo service

  @omniauth
  Scenario: Authorize using Facebook Account
    Given I am recognized as facebook user "Seamoo Test"
    When I go to the secured home index page
    And I follow "Facebook"
    Then I should be on the secured home index page
    And I should see "hello, Seamoo Test"
    And a user should exist with display_name: "Seamoo Test", email: "seamoo.test@fbmail.com"
