
Feature: Manage Parsers

  @vcr
  Background:
    Given a user exists with:
      | attribute | value             |
      | name      | Admin User        |
      | email     | admin@example.com |
      | role      | admin             |
    And partner and data source exist
    Given I am logged in as "admin@example.com"


  Scenario: Create a new parser
    When I visit "/parsers"
    And I click the link "New Parser Script"
    Then I should see "Create a New Parser Script"
    When I fill in "Parser Script Name" with "Test Script"
    Then I select contributor from "Contributor" and data source from "Data Source"

    And I select "JSON" from "Data Format"
    And I click button "Create Parser Script"
    Then I should see "Test Script"
