source 'http://rubygems.org'

gemspec

gem 'scidea', :path => '../scidea'

gem 'rails', '>= 3.2'

# db
gem 'mysql2', '>= 0.3'

# Deploy with Capistrano
gem 'capistrano'

# authentication and authorization
gem 'devise', '< 2.0'
gem 'cancan'

gem 'rake', '>= 0.9.0'

gem 'activemerchant', :require => 'active_merchant'
gem "bartt-ssl_requirement", '~> 1.4.0', :require => 'ssl_requirement' #bartt is a fork
gem 'paperclip', '= 2.6.0'
gem 'rubyzip'
gem 'formtastic', '= 2.0.2'
gem 'will_paginate', '~> 3.0'
gem 'mime-types'
gem 'json', '~> 1.5.1'
gem 'flash_messages_helper'
gem 'timeliness', '>= 0.3.3'
gem 'apotomo', '~>1.2.0'
gem 'cells', '= 3.7.1'
gem 'auto_strip_attributes'
gem 'nokogiri'
gem 'chronic'
gem 'simple-navigation'

gem 'tinymce-rails', :git => 'git://github.com/johnloy/tinymce-rails.git', :branch => 'upgrade-tinymce-jquery-to-3.5b3'

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
  gem 'compass-rails'
end

# provides jquery_ujs.js, jquery.js, and jquery-ui.js in the pipeline
gem 'jquery-rails'

group :production do
  gem 'newrelic_rpm'
end

group :test, :development do
  gem 'parallel_tests'
  gem 'rspec-rails'
  gem 'jasmine'
  gem 'guard-jasmine'
  gem 'guard-coffeescript'
  gem 'generator_spec'
  gem 'pry'
end

group :development do
  gem 'awesome_print'
  gem 'rails3-generators'

  # necessary for guard to prevent FS polling (which is very slow)
  gem 'rb-fsevent', :require => false

  gem 'jslint_on_rails'
  gem 'guard-jslint-on-rails'
end

group :test do
  gem 'rspec_tag_matchers'
  gem 'factory_girl_rails', '~> 3.2'
  gem 'autotest'  
  gem 'autotest-rails'
  gem 'database_cleaner'
  gem 'spork'
  gem 'launchy', '>= 0.4.0'    # So you can do Then show me the page
  gem 'cucumber'
  gem 'cucumber-rails', ">= 0.5.1", :require => false
  gem 'pickle'
  gem 'capybara'
  gem 'selenium-webdriver', '2.17.0' #2.18.0 introduces a bug preventing JS tests w/ modal dialog boxes from passing
  gem 'shoulda', '>= 3.0.0.beta'
  gem 'email_spec'
  gem 'simplecov', :require => false
  gem 'timecop'
  gem 'mocha'
end
