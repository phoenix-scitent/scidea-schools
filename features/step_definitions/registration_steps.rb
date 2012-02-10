Given /^I complete the registration form$/ do
  step %{I follow "Sign up"}
  step %{I fill in the core registration fields}
  step %{I press "Register"}
end

Given /^I fill in the core registration fields$/ do
  step %{I fill in "user_email" with "learner01@test.local"}
  step %{I fill in "user_password" with "password"}
  step %{I fill in "user_password_confirmation" with "password"}
  step %{I fill in "user_profile_attributes_first_name" with "Test"}
  step %{I fill in "user_profile_attributes_last_name" with "Learner"}
  step %{I select "Ms." from "user_profile_attributes_salutation"}
  step %{I select "1980" from "user_profile_attributes_birthdate_1i"}
  step %{I select "January" from "user_profile_attributes_birthdate_2i"}
  step %{I select "1" from "user_profile_attributes_birthdate_3i"}
end
