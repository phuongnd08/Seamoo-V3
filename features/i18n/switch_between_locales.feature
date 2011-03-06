Feature: Switch between locales
  In order to use Seamoo in multiple languages
  As a user
  I want to be able to switch between locales

  Background:
    Given a user exists with display_name: "mike"

  Scenario: Switch back and forth between English & Vietnamese
    When mike go to the home page
    Then mike should see "Hello, mike"
    When mike follow "Tiếng Việt"
    Then mike should see "Xin chào, mike"
    When mike follow "English"
    Then mike should see "Hello, mike"
