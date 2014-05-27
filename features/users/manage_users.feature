Feature: Manage Users

  Background:
    Given a user exists with:
      | attribute | value             |
      | name      | Admin User        |
      | email     | admin@example.com |
      | role      | admin             |
    Given a user exists with:
      | attribute | value            |
      | name      | Standard User    |
      | email     | user@example.com |
    Given I am logged in as "admin@example.com"
  
  Scenario: Create a new user
    When I visit "/users"
    And I click the link "New user"
    Then I should see "New user"
    When I fill in "Name" with "Another User"
    And I fill in "Email" with "anotheruser@example.com"
    And I fill in "user_password" with "password"
    And I fill in "user_password_confirmation" with "password"
    And I select "User" from "Role"
    And I check "Active"
    And I click button "Create User"
    Then I should see "anotheruser@example.com"

  Scenario: Change User's Role
    When I visit "/users"
    And I click link "Standard User"
    And I select "Admin" from "Role"
    And I click button "Update User"
    Then "Standard User" should be an admin
