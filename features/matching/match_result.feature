Feature: Match Result
  In order to review my performance
  As a user
  I want to review my match result

  Background:
    Given a user: "mike" exists with display_name: "mike"
    And a user: "peter" exists with display_name: "peter"
    And a user: "eric" exists with display_name: "eric"
    And a category: "English" exists
    And a league: "Amateur" exists with category: category "English", name: "Amateur"
    And league Amateur has 3 questions
    And a match exists with league: league "Amateur"
    And a match user exists with match: the match, user: user "mike"
    And a match user exists with match: the match, user: user "peter"
    And first Amateur match use default questions
    And peter made 2 correct answers
    And peter made 1 incorrect answers
    And mike made 1 correct answers

  Scenario: Peter viewing match result
    When peter go to the match page
    Then peter should see "1. You (peter) - 67% correct"
    And peter should see "2. mike - 33% correct"
    And peter should see "Question #1"
    And peter should see "You: Option #a - correct"
    And peter should see "mike: Option #a - correct"
    And peter should see "Question #2"
    And peter should see "You: Option #a - correct"
    And peter should see "mike: not answered"
    And peter should see "Question #3"
    And peter should see "You: Option #b - incorrect"
    And peter should see "mike: not answered"
    And peter should see "correct answer: Option #a"

  Scenario: Eric viewing match result
    When eric go to the match page
    Then eric should see "1. peter - 67% correct"
    And eric should see "2. mike - 33% correct"
    And eric should see "Question #1"
    And eric should see "peter: correct"
    And eric should see "mike: correct"
    And eric should see "Question #2"
    And eric should see "peter: correct"
    And eric should see "mike: not answered"
    And eric should see "Question #3"
    And eric should see "peter: incorrect"
    And eric should see "mike: not answered"
    And eric should not see "correct answer: Option #a"

