#require 'rubygems'
#require 'bundler/setup'

#require 'your_gem_name' # and any other gems you need

ENV["RAILS_ENV"] ||= 'test'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
 
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
