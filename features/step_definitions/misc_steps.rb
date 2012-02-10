Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value_or_text, field|
  is_value = find_field(field).value =~ /#{value_or_text}/
  is_text = field_labeled(field).find(:xpath, ".//option[text() = '#{value_or_text}']").selected?

  (is_value || is_text).should be_true
end

# @javascript only
Given /^I follow "([^"]*)" after "([^"]*)" loads$/ do |link, pending_content|
  wait_until{ !page.find(:css, pending_content).nil? }
  click_link(link)
end

# @javascript only
When /^(?:|I )select "([^"]*)" from "([^"]*)" after "([^"]*)" loads$/ do |value, field, pending_content|
  wait_until{ !page.find(:css, pending_content).nil? }
  select(value, :from => field)
end

# @javascript only
Then /^"([^"]*)" should be selected for "([^"]*)" after "([^"]*)" loads$/ do |value, field, pending_content|
  wait_until{ !page.find(:css, pending_content).nil? }
  step "\"#{value}\" should be selected for \"#{field}\""
end

When /^I accept the (?:popup|confirmation dialog)$/ do
  page.driver.browser.switch_to.alert.accept
end


Then /^"([^"]*)" should not contain option "([^"]*)"$/ do |field, value|
  field_labeled(field).has_no_xpath?(".//option[text() = '#{value}']").should be_true
end


Then /^the page title should contain "([^"]*)"$/ do |text|
    page.find('head title').text.include?(text).should be_true
end

Then /^"([^"]*)" should not be selected for "([^"]*)"$/ do |value, field|
  lambda{field_labeled(field).find(:xpath, ".//option[@selected][contains(string(), '#{value}')]") }.should raise_error
end

Then /^the (\d+)(?:st|nd|rd|th)(?: non-link|) item in the table should be "([^"]+)"$/ do |i, text|
  tables = page.all("table")
  tables.any?{ |table| table.all("tbody tr td")[i.to_i - 1].text.strip == text }.should be_true
end

Then /^the (\d+)(?:st|nd|rd|th)(?: non-link|) item in the table should start with "([^"]+)"$/ do |i, text|
  tables = page.all("table")
  tables.any?{ |table| table.all("tbody tr td")[i.to_i - 1].text.strip =~ /^#{text}/ }.should be_true
end
