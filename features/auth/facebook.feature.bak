Feature: Login using Facebook
As a Facebook User
I want to authenticated to Seamoo
So I can use Seamoo service

@javascript
Scenario: Authorize using Facebook Account
Given I am on "http://m.facebook.com/"
And I will
  |action|if I see|
  |follow "Logout"|Logout|
  ||Log In|
Given I am logged in Facebook as "seamoo.test@gmail.com/seamoo.secret"
When I go to the secured home index page
And I follow "Facebook"
Given I will
  |action|if I see|
  |press "Allow"|Request for Permission|
  ||Hello Seamoo Tast|
Then I should be on the secured home index page
And I should see "Hello Seamoo Tast"
And I should have user
  |field|value|
  |display name|Seamoo Tast|
  |email|seamoo.test@gmail.com|