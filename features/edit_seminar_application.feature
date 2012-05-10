Feature: edit seminar application
  As an admin, I want to edit a seminar application, so that I can take action to approve/deny/wailist it.

  Background:
    Given there exists a menu element "Seminars" linking to "/admin/seminars" for menu "Admin Navigation: Secondary"
    Given I login as a new "course admin"
  
  Scenario: a seminar application status is updated, triggering an email to the applicant
    Given there exists a seminar application for seminar "first seminar" and user "one@scitent.com" named "aaa"
    Given user "one@scitent.com" has school "Madison School"
    Given seminar "first seminar" has application form "my application" 
    Given there exists a "required" "text field" field "my text" in "my application"
    Given there exists a "dropdown list" field "my dropdown list" in "my application" with options "first,second,third"
    Given field "my text" in seminar application form "my application" for user "one@scitent.com" is set to "blah"
    Given field "my dropdown list" in seminar application form "my application" for user "one@scitent.com" is set to "second"
    When I go to the seminars admin page
    And I follow "All Applications"
    And I should see "aaa, aaa"
    And I should see "Displaying 1 seminar application"
    Given a clear email queue
    When I follow "Edit"
    Then I should see "Editing Seminar Application"
    And I should see "first seminar"
    And I should see "aaa"
    And I should see "one@scitent.com"
    And I should see "Madison School"
    And "second" should be selected for "my dropdown list"
    And the "my text" field should contain "blah"
    And "seminar_application[status]" should not contain option "Enrolled"
    When I select "Approved" from "seminar_application[status]"
    And I fill in "my text" with ""
    And I check "Waive fee"
    And I press "Submit"
    Then I should see "can't be blank"
    And "Approved" should be selected for "seminar_application[status]"
    And I fill in "my text" with "some text"
    And I press "Submit"
    Then I should see "Seminar application was successfully updated."
    Then "one@scitent.com" should receive an email
    When "one@scitent.com" opens the email with subject "Seminar Application Approved"
    When they click the first link in the email
    Then I should be on the learner dashboard
