Given /^there exists a(?:n?) audience "([^"]*)"$/ do |name|
  Factory :audience, :name => name
end

Given /^I have "([^"]*)" as my audience$/ do |name|
  audience = Audience.find_by_name(name) || Factory(:audience, :name => name)
  me = User.first
  me.profile.audience = audience
  me.profile.save!
end
