Given /^there exist(?:s?) "([^"]*)" school(?:s?)(?: in zipcode "([^"]*)")?$/ do |schools_count, zipcode|
  schools_count.to_i.times { zipcode.nil? ? FactoryGirl.create(:school) : FactoryGirl.create(:school, :zipcode => zipcode) }
end

Given /^there exists an unapproved school "([^"]*)"$/ do |school_name|
  FactoryGirl.create :school, :name => school_name, :approved => false
end

Given /^there exists a school "([^"]*)"(?: in "([^"]*)")?$/ do |school_name, city_state|
  if city_state
    FactoryGirl.create :school, :name => school_name, :city => city_state.split(',')[0], :state => city_state.split(',')[1]
  else
    FactoryGirl.create :school, :name => school_name
  end
end

Given /^there exists a school "([^"]*)" in zipcode "([^"]*)"$/ do |school_name, zipcode|
  if zipcode
    FactoryGirl.create :school, :name => school_name, :zipcode => zipcode
  else
    FactoryGirl.create :school, :name => school_name
  end
end

Given /^there exists a learner associated with the school "([^"]*)"$/ do |school_name|
  school = School.find_by_name(school_name) || FactoryGirl.create(:school, :name => school_name)
  FactoryGirl.create :user_learner, :profile => FactoryGirl.create(:profile, :school => school)
end

Given /^my school is "([^"]*)" in zipcode "([^"]*)"$/ do |school_name, zipcode|
  school = School.find_by_name(school_name) || FactoryGirl.create(:school, :name => school_name, :zipcode => zipcode)
  me = User.first
  me.profile.school = school
  me.profile.save!
end
