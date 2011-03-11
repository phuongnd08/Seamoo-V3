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
    And mike should not be able to see "#exit"
    And mike should not be able to see "#players"
    When peter match on league Amateur
    Then peter should see "Match will be started in ? seconds" within "#status"
    And peter should be able to see "#exit"
    And peter should be able to see "#players"
    When mike match on league Amateur
    Then mike should see "Match will be started in ? seconds" within "#status"
    And mike should see "peter" within "#players"
    And mike should see "mike" within "#players"
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
    And mike should see "mike (finished)"
    When peter match on league Amateur 
    Then peter should see "Match started" within "#status"
    And peter should see "Question #1"
    And mike should see "mike (finished)"
    When peter press "Option #a"
    Then peter should see "Question #2"
    When peter press "Option #b"
    And mike should see "mike (finished)"
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

  Scenario: Fast bird wait for match to end
    #First make sure both players will be registered in match
    Given mike is already at the last question
    When mike match on league Amateur
    And mike should see "Question 3/3"
    Then mike should see "Question #3"
    When mike press "Option #a"
    Then mike should see "You have finished the match" within "#status"
    Given first Amateur match is ended
    Then mike should soon be on the match result of first match page

  Scenario: No players finished before the match ended
    #First make sure both players will be registered in match
    Given mike is already at the last question
    And first Amateur match will be ended in 3 seconds
    When mike match on league Amateur
    And mike should see "Question 3/3"
    And mike should soon be on the match result of first match page

  Scenario: Rejoin match after leave
    #First make sure both players will be registered in match
    Given mike will confirm "Leave current match?"
    When mike press "Leave current match"
    Then mike should soon be on the league Amateur page
    When mike match on league Amateur
    Then mike should see "Waiting for other players"
