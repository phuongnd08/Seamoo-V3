@javascript
Feature: Home Page
  In order to know what leagues a category contains
  As a visitor
  I would like to see link

  Background:
    Given a category: "math" exists with name: "Math"
    And a league: "intermediate" exists with name: "Intermediate", category: category "math"
    When I am on the category: "math" page

  Scenario: See And Follow League
    Then I should see "Intermediate"
    When I follow "Intermediate"
    Then I should be on the league: "intermediate" page
