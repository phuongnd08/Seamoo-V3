Feature: Login using Google Federated Login Service
As a Google User
I want to authenticated to Seamoo
So I can use Seamoo service

@javascript
Scenario: Authorize using Google Federated Login Service
Given I am logged in Google as "seamoo.test/seamoo.secret"
When I go to the secured home index page
Then I should see "seamoo.com is requesting for some information"
When I press "Grant"
Then I should be on the secured home page
And I should see "Hello Seamoo Test"
And I should see "seamoo.test@gmail.com"

@javascript
Scenario: Cancel authorization using Google Federated Login Service