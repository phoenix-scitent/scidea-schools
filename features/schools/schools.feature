Feature: learners register and select a school with which they are associated
  As a learner, I need to specify my school when I register for the site

  Background:
    Given all roles are loaded
    Given default admin menus exist
    Given there exists an audience "Educator"
    Given I go to the home page

  @javascript
  Scenario: learner chooses educator from audience, but does not see the school fields because there are no schools in the system
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    Then I should not see "zipcode before selecting a school"

  @javascript
  Scenario: learner chooses school during registration
    Given there exist "4" schools in zipcode "12345"
    Given there exists a school "My Favorite School" in zipcode "12345"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I select "My Favorite School" from "School" after ".schools-found" loads
    And I press "Register"
    Then I should be logged in
    And I follow "Logout"

  @javascript
  Scenario: user searches for school based on zipcode but yields no results
    Given there exist "1" school in zipcode "12345"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "00000"
    Then I should see "No educational institutions found"

  @javascript
  Scenario: user searches for a school twice with two different zipcodes
    Given there exists a school "My Favorite School" in zipcode "12345"
    Given there exists a school "My Least Favorite School" in zipcode "00000"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I select "My Favorite School" from "School" after ".schools-found" loads
    And I fill in "school-select-zipcode" with "00000"
    And "School" should not contain option "My Favorite School"
    And I select "My Least Favorite School" from "School"

  @javascript
  Scenario: learner fails to choose school during registration and fails validation
    Given there exists a school "My Favorite School"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I press "Register"
    Then I should see "Educational institution required"

  @javascript
  Scenario: learner adds a new school during registration and sees that school automatically assigned
    Given there exist "2" schools in zipcode "12345"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I follow "Add a new one." after ".schools-found, .schools-not-found" loads
    And I fill in "Name" with "My Favorite School" within "#new-school-form"
    And I fill in "Address" with "400 Preston" within "#new-school-form"
    And I fill in "Address 2" with "Ste 300" within "#new-school-form"
    And I fill in "City" with "Cville" within "#new-school-form"
    And I select "Virginia" from "State" within "#new-school-form"
    And I fill in "Zipcode" with "22902" within "#new-school-form"
    And I fill in "Phone" with "9876543210" within "#new-school-form"
    And I press "Add Institution"
    Then "My Favorite School" should be selected for "school-id"
    And I press "Register"
    And I follow "Edit My Profile"
    Then "My Favorite School" should be selected for "school-id"

  @javascript
  Scenario: learner adds a school with a zipcode starting with 0
    Given there exist "1" schools in zipcode "01234"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "01234"
    And I follow "Add a new one." after ".schools-found, .schools-not-found" loads
    And I fill in "Name" with "My Favorite School" within "#new-school-form"
    And I fill in "Address" with "400 Preston" within "#new-school-form"
    And I fill in "Address 2" with "Ste 300" within "#new-school-form"
    And I fill in "City" with "Cville" within "#new-school-form"
    And I select "Virginia" from "State" within "#new-school-form"
    And I fill in "Zipcode" with "01234" within "#new-school-form"
    And I fill in "Phone" with "9876543210" within "#new-school-form"
    And I press "Add Institution"
    Then "My Favorite School" should be selected for "school-id"

  @javascript
  Scenario: learner fails to add new school during registration because of validation issues
    Given there exist "2" schools in zipcode "12345"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I follow "Add a new one." after ".schools-found, .schools-not-found" loads
    And I fill in "Name" with "My Favorite School" within "#new-school-form"
    And I fill in "Address" with "400 Preston" within "#new-school-form"
    And I select "Virginia" from "State" within "#new-school-form"
    And I fill in "Phone" with "9876543210" within "#new-school-form"
    And I press "Add Institution"
    Then I should see "can't be blank"
    And "My Favorite School" should not be selected for "school-id"
    And I fill in "City" with "Cville" within "#new-school-form"
    And I press "Add Institution"
    Then "My Favorite School" should be selected for "school-id"
    And I press "Register"
    And I follow "Edit My Profile"
    Then "My Favorite School" should be selected for "school-id"

  @javascript
  Scenario: learner adds a new school, but decides to edit it
    Given there exists "1" school in zipcode "00000"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I follow "add a new institution." after ".schools-not-found" loads
    And I fill in "Name" with "My Favorite School" within "#new-school-form"
    And I fill in "Address" with "400 Preston" within "#new-school-form"
    And I fill in "City" with "Cville" within "#new-school-form"
    And I select "Virginia" from "State" within "#new-school-form"
    And I fill in "Zipcode" with "22902" within "#new-school-form"
    And I fill in "Phone" with "9876543210" within "#new-school-form"
    And I press "Add Institution"
    Then "My Favorite School" should be selected for "school-id"
    Then I follow "edit it." after "#edit-school" loads
    And I fill in "Name" with "My Least Favorite School" within "#new-school-form"
    And I press "Update Institution"
    Then "My Least Favorite School" should be selected for "school-id"
    And "school-id" should not contain option "My Favorite School"
    And I press "Register"
    And I follow "Edit My Profile"
    Then "My Least Favorite School" should be selected for "school-id"

  @javascript
  Scenario: learner selects school but registration form fails to validate; school should be selected
    Given there exists form "Profile" of type "Registration"
    Given there exists a school "My Favorite School" in zipcode "12345"
    Given there exists a "required" "text field" field "custom field" in "Profile"
    When I follow "Sign up"
    And I fill in the core registration fields
    And I select "Educator" from "Profession"
    And I fill in "school-select-zipcode" with "12345"
    And I select "My Favorite School" from "School" after ".schools-found" loads
    And I press "Register"
    And I fill in the core registration fields
    And I fill in "custom field" with "blah"
    Then "My Favorite School" should be selected for "School" after ".schools-found" loads
    Then the "school-select-zipcode" field should contain "12345"
    And I press "Register"
    And I follow "Edit My Profile"
    Then "My Favorite School" should be selected for "School" after ".schools-found" loads
      
  @javascript
  Scenario: when editing profile, user's school and zipcode should be selected and changes should persist
    Given I login as a new learner
    Given there exists a school "My New School" in zipcode "00000"
    Given my school is "My Favorite School" in zipcode "12345"
    Given I have "Educator" as my audience
    And I follow "Edit My Profile"
    Then the "school-select-zipcode" field should contain "12345"
    And "My Favorite School" should be selected for "School" after ".schools-found" loads
    Then I fill in "school-select-zipcode" with "00000"
    And I select "My New School" from "School" after ".schools-found" loads
    And I press "Update"
    And I follow "Edit My Profile"
    And "My New School" should be selected for "School" after ".schools-found" loads
    
  @javascript
  Scenario: admin edits user and goes to create a new school
    Given I login as a new "scitent admin"
    Given there exists learner "aaa@test.local" named "bbb"
    Given user "aaa@test.local" has school "Madison School"
    When I follow "Users"
    When I fill in "search" with "bbb"
    And I press "Search"
    When I follow "Edit"
    And I follow "Add a new one." after ".schools-found, .schools-not-found" loads
    Then I should be on the new school page
    
  @javascript
  Scenario: admin edits user and changes their school
    Given there exists a school "My New School" in zipcode "00000"
    Given I login as a new "scitent admin"
    Given there exists learner "aaa@test.local" named "bbb"
    Given user "aaa@test.local" has school "Madison School"
    When I follow "Users"
    When I fill in "search" with "bbb"
    And I press "Search"
    When I follow "Edit"
    And "Madison School" should be selected for "School" after ".schools-found" loads
    And I fill in "school-select-zipcode" with "00000"
    And I select "My New School" from "School" after ".schools-found" loads
    And I press "Update"
    Then I should see "My New School"
