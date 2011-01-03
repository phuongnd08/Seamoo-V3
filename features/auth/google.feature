Feature: Login using Google Federated Login Service
As a Google User
I want to authenticated to Seamoo
So I can use Seamoo service

@javascript
Scenario: Authorize using Google Account
Given I am logged in Google as "seamoo.test/seamoo.secret"
When I go to the secured home index page
And I follow "Google"
Given I will
  |action|if I see|
  |press "Allow"|is asking for some information from your Google Account seamoo.test@gmail.com|
  ||Hello Seamoo Test|
Then I should be on the secured home index page
And I should see "Hello Seamoo Test"
And I should have user
  |field|value|
  |display name|Seamoo Test|
  |email|seamoo.test@gmail.com|