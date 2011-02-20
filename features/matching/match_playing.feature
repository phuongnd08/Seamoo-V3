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
    And league Amateur of English is openning
    And league Amateur has 3 questions
    And all data is fresh
    #First make sure both players will be registered in match
    When mike match on league Amateur
    Then mike should see "Waiting for other players"
    When peter match on league Amateur
    Then peter should see "Match will be started in ? seconds" within "#status"
    When mike match on league Amateur
    Then mike should see "Match will be started in ? seconds" within "#status"
    #Then start verify the flow
    Given first Amateur match use default questions

  Scenario: Normal matching flow
    Then mike should see "Match started" within "#status"
    And mike should see "There are ? seconds left" within "#status"
    And mike should see "Question 1/3"
    And mike should see "Question #1"
    When mike press "Option #a"
    And mike should see "Question 2/3"
    Then mike should see "Question #2"
    When mike press "Option #b"
    And mike should see "Question 3/3"
    Then mike should see "Question #3"
    When mike press "Option #a"
    Then mike should see "You have finished the match" within "#status"
    When peter match on league Amateur 
    Then peter should see "Match started" within "#status"
    And peter should see "Question #1"
    When peter press "Option #a"
    Then peter should see "Question #2"
    When peter press "Option #b"
    Then peter should see "Question #3"
    When peter press "Option #a"
    And peter should soon be on the match result of first match page

  Scenario: Fast bird wait for match to finish
    #First make sure both players will be registered in match
    Given mike is already at the last question
    When mike match on league Amateur
    And mike should see "Question 3/3"
    Then mike should see "Question #3"
    When mike press "Option #a"
    Then mike should see "You have finished the match" within "#status"
    Given peter finished his match
    Then mike should soon be on the match result of first match page
