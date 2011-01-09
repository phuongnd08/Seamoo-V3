Feature: Edit follow pattern question
As an admin
I want to be able to edit follow pattern question
So I can correct typos if any

Background:
Given I edit this follow pattern question
  |instruction|pattern|
  |Your name|ph[uon]g|

@javascript
Scenario: Edit instruction & pattern
When I fill in the following:
  |Instruction|Your nickname|
  |Pattern    |phuon[g]|
And I press "Save"
Then I should have this follow pattern question
  |instruction|pattern|
  |Your nickname|phuon[g]|