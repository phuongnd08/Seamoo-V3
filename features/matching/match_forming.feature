Feature: Match forming
  In order to having match
  As a user
  I want my request to join a match fullfiled

  Background:
    Given these users
      |peter|
      |mike|
      |tom|
      |jeff|
      |suman|
      |eric|
    And category English is available
    And league Amateur of English is openning
    And all data is fresh

  Scenario: First user joining
    When peter want to join Amateur
    Then no match is formed for peter

  Scenario: Two users joining
    When peter want to join Amateur
    And mike want to join Amateur
    And peter still want to join Amateur 
    Then an Amateur match is formed for peter and mike

  Scenario: Joining league when all match is full
    Given an Amateur match between peter and mike and tom and jeff formed
    When suman want to join Amateur
    Then no match is formed for suman
    When eric want to join Amateur
    And suman still want to join Amateur 
    Then an Amateur match is formed for eric and suman

  Scenario: Joining league when all match is already started
    Given an Amateur match between peter and mike is started
    When jeff want to join Amateur
    And eric want to join Amateur
    And jeff still want to join Amateur
    Then an Amateur match is formed for jeff and eric

  Scenario: Joining league when last requester left
    Given peter want to join Amateur 10 minutes ago
    And mike want to join Amateur
    And suman want to join Amateur
    And eric want to join Amateur
    And jeff want to join Amateur
    Then no match is formed for peter
    When mike still want to join Amateur
    Then an Amateur match is formed for mike and suman and eric and jeff

  Scenario: Request again should not form a new match
    Given an Amateur match between peter and mike is started
    When peter want to join Amateur
    And eric want to join Amateur
    And peter still want to join Amateur
    Then no match is formed for eric
    And there is only 1 Amateur match for peter

  Scenario: Request again after match finished should form a new match
    Given an Amateur match between peter and mike is finished
    When peter want to join Amateur
    And eric want to join Amateur
    And peter still want to join Amateur
    Then an Amateur match is formed for eric and peter
    And there is 2 Amateur matches for peter

  Scenario: Request again after explicitly request to leave current match should form a new match
    Given an Amateur match between peter and mike is started
    When peter request to leave his current Amateur match
    And peter want to join Amateur
    And eric want to join Amateur
    And peter still want to join Amateur
    Then an Amateur match is formed for eric and peter
    And there is 2 Amateur matches for peter
