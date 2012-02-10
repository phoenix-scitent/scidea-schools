Given /^there exists learner "([^"]*)"(?: with password "([^"]*)")?$/ do |email, password|
  Factory(:user_learner, :email => email)
end

Given /^there exists learner "([^"]*)" named "([^"]*)"(?: with password "([^"]*)")?$/ do |email, name, password|
  Factory(:user_learner, :email => email, :profile => Factory(:profile, :last_name => name, :first_name => name))
end

Given /^user "([^"]*)" has school "([^"]*)"$/ do |email, school|
  profile = User.find_by_email(email).profile
  school = School.find_by_name( school ) || Factory(:school, :name => school)
  audience = Audience.find_by_name( 'Educator' ) || Factory(:audience, :name => 'Educator')
  profile.school = school
  profile.audience = audience
  profile.save!
end
