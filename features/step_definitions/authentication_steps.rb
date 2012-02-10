Given /^I login as a new learner$/ do
  step %{I login as a new "learner"}
end

Given /^I login as a new "([^"]*)"$/ do |user_role|
  password = 'password'
  role_to_factory = { 'scitent admin' => :user_scitent_admin,
    'tech support' => :user_tech_support,
    'product admin' => :user_product_admin,
    'course admin' => :user_course_admin,
    'user admin' => :user_user_admin,
    'learner' => :user_learner
  }
  user = Factory(role_to_factory[user_role], :password => password)

  step %{I logout}
  visit('/')
  fill_in('user_email', :with => user.email)
  fill_in('user_password', :with => password)
  click_button('Sign in')
end

Then /^(?:|I )should be logged in$/ do
  text = 'Edit My Profile'
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Given /^I logout$/ do
  visit('/users/sign_out')
end
