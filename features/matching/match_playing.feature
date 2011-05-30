@javascript @screenshot @focus
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
    And all matches will immediately start
    #First make sure both players will be registered in match
    When mike match on league Amateur
    Then mike should see "Waiting for other players" within "#status"
    When peter match on league Amateur
    Then peter should see "Match started" within "#status"
    #Second make sure match use predictable questions
    Given first Amateur match use default questions
    When mike match on league Amateur
    Then mike should see "Match started" within "#status"
    #Then start verify the flow

  Scenario: Normal matching flow
    #See spec/integrations/playing_spec.rb for rspec implemenation

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

  Scenario: Questions should not be messed up due to match infor updates
    Given question submission is delayed
    When mike press "Option #a"
    Then mike should see "Question 2/3"
    When mike wait for 2 seconds
    Then mike should see "Question 2/3"
