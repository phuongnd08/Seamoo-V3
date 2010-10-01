Feature: Home Page
In order to know what leagues a category contains
As a visitor
I would like to see link

Background:
    Given There is a category named "Math"
    And There is a league named "Intermediate" in "Math"
    When I am on the show category "Math" page

Scenario: See And Follow League
    Then I should see "Intermediate"
    When I follow "Intermediate"
    Then I should be on the show league "Intermediate" page