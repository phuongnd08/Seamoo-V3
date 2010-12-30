Feature: Login using Google Federated Login Service
As a Google User
I want to authenticated to Seamoo
So I can use Seamoo service

@javascript
Scenario: Authorize using Google Account
Given I am logged in Google as "seamoo.test/seamoo.secret"
When I go to the secured home index page
And I follow "Google"
Then I should see "is asking for some information from your Google Account seamoo.test@gmail.com"
Then I should see "Seamoo Test"
When I press "Allow"
Then I should be on the secured home index page
And I should see "Hello Seamoo Test"
And I should have user account "Seamoo Test/seamoo.test@gmail.com"

@javascript
Scenario: Cancel authorization using Google Account