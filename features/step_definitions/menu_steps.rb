Given /^there exists a menu element "([^"]*)" linking to "([^"]*)" for menu "([^"]*)"$/ do |name, url, menu_name|
  menu = Menu.find_by_name(menu_name) || Factory(:menu, :name => menu_name)
  Factory(:menu_element_admin_with_url, :display_name => name, :menu => menu, :url => url)
end
