@javascript
Feature: Disable al buttons while submitting answer
  In order to play match properly
  As a user
  I want buttons to be disabled until the next answer is ready

  Background:
    Given these users
      |peter|
      |mike|
    And category English is available
    And league Amateur of English is openning
    And all data is fresh
    And all matches will immediately start
    
  Scenario: Disable buttons for multiple choice
    Given league Amateur has 3 multiple choice questions
    #First make sure both players will be registered in match and the preferred questions loaded
    When mike match on league Amateur
    Then mike should see "Waiting for other players"
    When peter match on league Amateur
    Then peter should see "Question 1/3"
    Given first Amateur match use default questions
    When mike match on league Amateur
    #Then start verify the flow
    Then mike should see "Question #1"
    Given submitting answers will be delayed
    When mike press "Option #a"
    Then mike should not be able to press "Option #a"
    And mike should not be able to press "Option #b"
    And mike should not be able to press "Ignore this question"
    Given submitting answers is resumed
    Then mike should be able to press "Option #a"
    And mike should be able to press "Option #a"
    And mike should be able to press "Ignore this question"

  Scenario: Disable buttons & inputs for multiple choice
    Given league Amateur has 3 follow pattern questions 
    When mike match on league Amateur
    Then mike should see "Waiting for other players"
    When peter match on league Amateur
    Then peter should see "Question 1/3"
    #Rehack the match to use just preditable follow pattern questions
    Given first Amateur match use default questions
    When mike match on league Amateur
    And mike should see "Follow Pattern #1"
    Given submitting answers will be delayed
    When mike fill in "answer" with "myanswer"
    And mike press "Submit"
    Then mike should not be able to edit "answer"
    And mike should not be able to press "Submit"
    And mike should not be able to press "Ignore this question"
    Given submitting answers is resumed
    Then mike should be able to edit "answer"
    And mike should be able to press "Submit"
    And mike should be able to press "Ignore this question"


