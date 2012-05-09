Given /^there exists form "([^"]*)"(?: of type "([^"]*)")?$/ do |form_name, form_type_name|
  form_type_name ||= 'My Form Type'
  FactoryGirl.create :form, :name => form_name, :form_type => FactoryGirl.create(:form_type, :name => form_type_name)
end

Given /^there exists an? "([^"]*)" "([^"]*)" field "([^"]*)" in "([^"]*)"$/ do |optional_or_required, field_type, field_name, form_name|
  form = Form.find_by_name(form_name) || FactoryGirl.create( :form, :name => form_name )
  form_section = form.form_sections.last || FactoryGirl.create( :form_section, :form => form )

  required = optional_or_required == 'required'
  field_sym = ('form_field_' + field_type.downcase.gsub(/ /, '_')).to_sym #converts field type string to factory symbol
  FactoryGirl.create field_sym, :name => field_name, :form_section => form_section, :required => required
end

Given /^there exists an? "([^"]*)" field "([^"]*)" in "([^"]*)" with options "([^"]*)"$/ do |field_type, field_name, form_name, option_list|
  form = Form.find_by_name(form_name) || FactoryGirl.create( :form, :name => form_name )
  form_section = form.form_sections.first || FactoryGirl.create( :form_section, :form => form )

  field_sym = ('form_field_' + field_type.downcase.gsub(/ /, '_')).to_sym #converts field type string to factory symbol
  field = FactoryGirl.create field_sym, :name => field_name, :form_section => form_section

  option_list.split(',').each do |option|
    FactoryGirl.create :form_field_option_value, :form_field => field, :value => option.strip
  end
end

Then /^the "([^"]*)" field should contain zipcode "([^"]*)"$/ do |label_text, zipcode|
  label_for = find('label', :text => label_text)[:for]
  zip1_id = label_for + '_us_zip1'
  zip2_id = label_for + '_us_zip2'
  find("##{zip1_id}").value.should == zipcode.split('-')[0]
  find("##{zip2_id}").value.should == ( zipcode.split('-')[1] || '' )
end
