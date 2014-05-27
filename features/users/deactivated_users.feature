Feature: Deactivated Users

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
    Given a user exists with:
      | attribute | value                   |
      | name      | Deactivated User        |
      | email     | deactivated@example.com |
      | active    | false                   |

  Scenario: Deactivated Users Cannot Login
    When I visit "/users/sign_in"
    And I am logged in as "deactivated@example.com"
    Then I should be on "/users/sign_in"
    And I should see "Your account was not activated yet."

  Scenario: View Active Users
    Given I am logged in as "admin@example.com"
    When I visit "/users"
    Then I should see "user@example.com"
    And I should not see "deactivated@example.com"

  Scenario: View Deactivated Users
    Given I am logged in as "admin@example.com"
    When I visit "/users?active=false"
    Then I should see "deactivated@example.com"
    And I should not see "user@example.com"

  Scenario: Cannot View Deactivated Users as Standard User
    Given I am logged in as "user@example.com"
    When I visit "/users"
    Then I should not see "Deactivated Users"
