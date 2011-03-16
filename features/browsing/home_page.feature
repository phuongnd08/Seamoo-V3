@javascript
Feature: Home Page
  In order to know what SeaMoo is about
  As a visitor
  I would like to see introduction and link

  Background:
    Given a coming soon category: "math" exists with name: "Math"
    And an active category: "language" exists with name: "Language"
    And I am on the home page

  Scenario: Introduction
    Then I should see "Competition system"

  Scenario: See And Follow Active Categories Headers
    Then I should see "Language"
    When I follow "Language"
    Then I should be on the category: "language" page

  Scenario: See And Follow Active Categories Main Links
    When I follow "Join now" within "#language"
    Then I should be on the category: "language" page

  Scenario: Coming soon category is unnavigatable
    Then I should see "Math"
    And "Math" is not a link
