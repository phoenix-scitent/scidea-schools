Feature: JavaScript Unit Tests
  As a developer, I want to ensure correct presentation logic

  @javascript
  Scenario: schools in the profile form
    And I run the qunit tests
    Then I should see no qunit failures
