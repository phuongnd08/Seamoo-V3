@javascript
Feature: Match using follow pattern question
  In order to play match
  As a user
  I want to be able to answer multiple choice question

  Background:
    Given these users
      | peter |
      | mike  |
    And category English is available
    And league Amateur of English is openning
    And league Amateur has 3 follow pattern questions 
    And all matches will immediately start
    And all data is fresh
    When mike match on league Amateur
    Then mike should see "Waiting for other players"
    When peter match on league Amateur
    Then peter should see "Question 1/3"
    Given first Amateur match use default questions
    When mike match on league Amateur
    #Then start verify the flow

  Scenario: Answer follow pattern question
    And mike should see "Question 1/3"
    And mike should see "Follow Pattern #1"
    When mike fill in "answer" with "myanswer"
    And mike press "Submit"
    Then mike's recorded answer of 1st question should be "myanswer"

  Scenario: Ignore multiple choice question
    And mike should see "Question 1/3"
    And mike should see "Follow Pattern #1"
    When mike press "ignore"
    Then mike's recorded answer of 1st question should be empty

