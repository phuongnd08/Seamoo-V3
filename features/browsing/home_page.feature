Feature: Home Page
In order to know what SeaMoo is about
As a visitor
I would like to see introduction and link

Background:
    Given There is a category named "Math"
    And I am on the home page

Scenario: Introduction
    Then I should see "Introduction"

Scenario: See And Follow Categories
    Then I should see "Math"
    When I follow "Math"
    Then I should be on the show category "Math" page