Feature: Categories Page
In order to know what category there are
As a visitor
I would like to see link

Scenario: Categories page
    Given There is a category named "Math"
    When I am on the categories page
    Then I should see "Math"
    When I follow "Math"
    Then I should be on the show category "Math" page