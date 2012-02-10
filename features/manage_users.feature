Feature: admins manage users
  As an admin I want to manage users

  Background:
    Given there exists a menu element "Users" linking to "/admin/users" for menu "Admin Navigation: Secondary"
    Given I login as a new "scitent admin"
 
  @javascript
  Scenario: admin edits user
    Given there exists learner "aaa@test.local" named "bbb"
    Given user "aaa@test.local" has school "Madison School"
    When I follow "Users"
    When I fill in "search" with "bbb"
    And I press "Search"
    Then I should see "bbb"
    When I follow "Edit"
    When I fill in "user[profile_attributes][last_name]" with "zzz"
    When I fill in "user[profile_attributes][first_name]" with "zzz"
    Then I should see "Madison School"
    And I press "Update"
    When I follow "Users"
    Then I should see "zzz, zzz"
    And I should not see "bbb, bbb"
