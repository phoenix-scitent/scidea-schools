Given /^seminar "([^"]*)" has application form "([^"]*)"$/ do |seminar_name, application_form|
  seminar = Seminar.find_by_name ( seminar_name ) || Factory(:seminar, :name => seminar_name)
  seminar.application_form = Factory(:form_seminar_application, :name => application_form)
  seminar.save!
end
