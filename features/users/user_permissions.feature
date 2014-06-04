Feature: User Permissions

  Background:
    Given a user exists with:
      | attribute | value            |
      | name      | Standard User    |
      | email     | user@example.com |
    Given I am logged in as "user@example.com"

  Scenario: Defaults
    And I visit "/sources"
    Then I should see selector ".button.disabled"

  Scenario: Manage Data Sources
    When the user has "manage_data_sources" set to "true"
    And I visit "/sources"
    Then I should not see selector ".button.disabled"

