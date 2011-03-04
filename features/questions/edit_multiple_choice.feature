@javascript
Feature: Edit multiple choice question
  As an admin
  I want to be able to edit multiple choice question
  So I can correct typos if any

  Background:
    Given I edit this multiple choice question
      |content|options|
      |What's your name|Nam\|*Phuong\|Hung\|Toan|

  Scenario: Edit content
    When I fill in "Content" with "What's your friend name"
    And I press "Save"
    Then I should have this multiple choice question
      |content|options|
      |What's your friend name|Nam\|*Phuong\|Hung\|Toan|

  Scenario: Add choice
    When I follow "Add choice"
    And I fill in last "Choice" with "Trien"
    And I check last "Correct"
    And I press "Save"
    Then I should have this multiple choice question
      |content|options|
      |What's your name|Nam\|*Phuong\|Hung\|Toan\|*Trien|

  Scenario: Remove choice
    When I press to remove choice "Toan"
    And I press "Save"
    Then I should have this multiple choice question
      |content|options|
      |What's your name|Nam\|*Phuong\|Hung|
