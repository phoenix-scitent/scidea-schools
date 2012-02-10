Given /^there exists a seminar application for seminar "([^"]*)" and user "([^"]*)" named "([^"]*)"$/ do |seminar_name, user_email, user_name|
  seminar = Seminar.find_by_name(seminar_name) || Factory(:seminar, :name => seminar_name)
  user = User.find_by_email(user_email) || Factory(:user, :email => user_email, :profile => Factory(:profile, :last_name => user_name, :first_name => user_name))
  seminar_application = Factory(:seminar_application, :seminar => seminar, :user => user)
  seminar_application.set_submitted
  seminar_application.save!
end

Given /^field "([^"]*)" in seminar application form "([^"]*)" for user "([^"]*)" is set to "([^"]*)"$/ do |field, form, email, value|
  seminar_application = SeminarApplication.last
  form_response = FormResponse.first || Factory(:form_response, :form => Form.find_by_name(form), :user => User.find_by_email(email))
  seminar_application.form_response = form_response
  seminar_application.save!
  Factory(:form_response_value, :form_field => FormField.find_by_name(field), :value => value, :form_response => form_response)
end

