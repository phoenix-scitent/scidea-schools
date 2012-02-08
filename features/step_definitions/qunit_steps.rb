def qunit_results
  result_str = "QUnit Results:\n\t" +
    page.find("#qunit-testresult").text.split("\n").join("\n\t")

  page.all(:xpath, "//ol[@id='qunit-tests']/li[@class='fail']").each do |element|
    result_str += "\n\t" + element.find("strong").text
  end

  result_str + "\n"
end

Then /I should see no qunit failures$/ do
  page.should have_css('#qunit-testresult')
  page.should_not have_css('li.fail'), qunit_results

end

Given /^I go to the qunit tests$/ do |test_name|
  visit("/test/scidea_schools_qunit_tests")
end
