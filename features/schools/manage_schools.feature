Feature: admins manage schools
  As an admin I want to manage subtopics

  Background:
    Given there exists a menu element "Educational Institution" linking to "/admin/schools" for menu "Admin Navigation: Secondary"

    Given there exists a menu element "Schools" linking to "/admin/schools" for menu "Admin Navigation: Secondary"
    Given I login as a new "scitent admin"

  Scenario: admin creates school
    When I follow "Schools"
    And I follow "New Educational Institution"
    And I fill in "Name" with "My Favorite School"
    And I fill in "Address" with "400 Preston"
    And I fill in "Address 2" with "Ste 300"
    And I fill in "City" with "400 Preston"
    And I select "Virginia" from "State"
    And I fill in "Zipcode" with "22902"
    And I fill in "Phone" with "9393939393"
    And I check "Approved"
    And I press "Submit"
    Then I should see "Educational institution was successfully created."
    And I should see "My Favorite School"
    And I should see "Virginia"
    And I should see "22902"
    And I should see "Yes"
    
  Scenario: admin searches/sorts/paginates schools
    Given there exists a school "My Favorite School"
    Given there exists a school "Your Favorite School"
    When I follow "Schools"
    Then the 1st non-link item in the table should be "My Favorite School"
    When I follow "Name"
    Then the 1st non-link item in the table should be "Your Favorite School"
    When I fill in "search" with "My"
    And I press "Search"
    Then I should see "My Favorite School"
    And I should not see "Your Favorite School"
  
  Scenario: admin edits school
    Given there exists a school "My Favorite School"
    When I follow "Schools"
    When I follow "Edit"
    When I fill in "Name" with "Nobody's Favorite School"
    And I press "Submit"
    And I should not see "My Favorite School"

  Scenario: admin approves a school
    Given there exists an unapproved school "My Favorite School"
    When I follow "Schools"
    When I follow "Edit"
    When I check "Approved"
    And I press "Submit"
    Then I should see "Approved: Yes"    

  Scenario: admin migrates all users from a school to another because it is a duplicate
    Given there exists a learner associated with the school "Richard Nixon School of Presidentialism"
    Given there exists a school "Nixon School of Presidentialism" 
    Given there exists a school "Richard M. Nixon School" in "Yorba Linda, CA"
    Given there exists a school "My Favorite School"
    When I follow "Schools"
    When I fill in "search" with "Richard Nixon School"
    And I press "Search"
    And I follow "Edit"
    And I follow "Migrate Users to Different Educational Institution"
    And I fill in "search" with "Richard M. Nixon"
    And I press "Search"
    Then I should see "Yorba Linda"
    And I should see "CA"
    And I should see "Richard M. Nixon School"
    And I follow "Choose"
    Then the page title should contain "Confirm User Migration between Educational Institution"
    Then I should see "Richard Nixon School of Presidentialism"
    And I should see "Yorba Linda"
    And I press "Yes, Migrate Users"
    Then I should see "Successfully migrated 1 user from Richard Nixon School of Presidentialism to Richard M. Nixon School" 
    And the page title should contain "Manage Educational Institutions"

  @javascript
  Scenario: admin deletes a school
    Given there exists a school "UVA"
    When I go to the schools admin page
    Then I should see "UVA"
    When I follow "Delete"
    When I accept the popup
    Then I should not see "UVA"
    And the page title should contain "Manage Educational Institutions"
