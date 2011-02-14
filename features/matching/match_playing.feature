@javascript
Feature: Match Playing
  In order to play match
  As a user
  I want to be shown match stuff

  Background:
    Given these users
      |peter|
      |mike|
    And category English is available
    And league Amateur is openning
    And league Amateur has 3 questions
    And all data is fresh

  Scenario: Normal matching flow
    When peter match on league Amateur
    Then peter should see "Waiting for other players"
    When mike match on league Amateur
    Then mike should see "Match will be started in ? seconds"
    Given first Amateur match use default questions
    Then mike should see "Match started"
    And mike should see "Question 1/3"
    And mike should see "Question #1"
    When mike press "Option #a"
    And mike should see "Question 2/3"
    Then mike should see "Question #2"
    When mike press "Option #b"
    And mike should see "Question 3/3"
    Then mike should see "Question #3"
    When mike press "Option #a"
    Then mike should see "You have finished your match"
    When peter match on league Amateur 
    Then peter should see "Match started"
    And peter should see "Question #1"
    When peter press "Option #1"
    Then peter should see "Question #2"
    When peter press "Option #2"
    Then peter should see "Question #3"
    When peter press "Option #3"
    Then peter should see "You have finished your match"
    And peter should be on the match result of first match page
