@javascript @screenshot @focus
Feature: Match Waiting
  In order to play match
  As a user
  I want to be indicated that I need to wait for other players

  Scenario: Waiting for match
    Given these users
      |peter|
      |mike|
    And category English is available
    And league Amateur of English is openning
    And league Amateur has 3 questions
    And all data is fresh
    And all matches will be started after 10 seconds
    #First make sure both players will be registered in match
    When mike match on league Amateur
    Then mike should see "Waiting for other players"
    And mike should not be able to see "#exit"
    And mike should not be able to see "#match_players"
    And mike should be able to see "#league_other_active_players .no_players"
    And mike should not be able to see "#league_other_active_players .list"
    When peter match on league Amateur
    Then peter should see "Match will be started in ? seconds" within "#status"
    And peter should be able to see "#exit"
    And peter should be able to see "#match_players"
    And peter should not be able to see "#league_other_active_players .no_players"
    And peter should be able to see "#league_other_active_players .list"
    And peter should see "mike" within "#league_other_active_players"
    When mike match on league Amateur
    Then mike should see "peter" within "#match_players"
    And mike should see "mike" within "#match_players"