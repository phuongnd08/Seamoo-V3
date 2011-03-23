Feature: View user profile
  In order to know about other or what other will know about me
  As a user
  I want to view my and other user profile

  Scenario: View my profile
    Given a user: "phuong" exists with display_name: "phuong", email: "phuong@gmail.com", date_of_birth: "2000/1/1"
    Given I am logged in as phuong
    When I am on the user: "phuong" page
    Then I should see "phuong" within "#display_name"
    And I should see "phuong@gmail.com" within "#email"
    And I should see "Jan 1, 2000" within "#birthday"
    When I follow "Edit"
    Then I should be on the edit user: "phuong" page

  Scenario: View other profile
